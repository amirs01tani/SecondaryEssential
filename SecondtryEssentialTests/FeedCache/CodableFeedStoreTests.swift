//
//  CodableFeedStoreTests.swift
//  SecondtryEssentialTests
//
//  Created by Amir on 1/19/24.
//

import Foundation
import XCTest
import SecondtryEssential

class CodableFeedStore {
    private let storeURL: URL
    
    init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    private struct Cache: Codable {
        let feed: [CodableFeedItem]
        let timestamp: Date
    
    }
    
    private struct CodableFeedItem: Codable {
        private let id: UUID
        private let description: String?
        private let location: String?
        private let imageURL: URL
        
        init(_ item: LocalFeedItem) {
            id = item.id
            description = item.description
            location = item.location
            imageURL = item.imageURL
        }
        
        var local: LocalFeedItem {
            return LocalFeedItem(id: id,description: description, location: location, imageURL: imageURL)
        }
    }
    
    func retrieve(completion: @escaping FeedStore.RetrieveCompletion) {
        guard let data = try? Data (contentsOf: storeURL) else { return completion(.empty) }
        let decoder = JSONDecoder()
        do {
            if let cache = try? decoder.decode(Cache.self, from: data) {
                completion(.found(feed: cache.feed.map { $0.local }, timestamp: cache.timestamp))
            } else {
                throw(anyNSError())
            }
        }
        catch {
            completion(.failure(error))
        }
    }
    
    func insert(_ feed: [LocalFeedItem], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
        let encoder = JSONEncoder()
        let encoded = try! encoder.encode(Cache(feed: feed.map(CodableFeedItem.init), timestamp: timestamp))
        try! encoded.write(to: storeURL)
        completion(nil)
    }
}

class CodableFeedStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        try? FileManager.default.removeItem(at: testSpecificStoreUrl())
    }
    
    override func tearDown() {
        super.tearDown()
        try? FileManager.default.removeItem(at: testSpecificStoreUrl())
    }
    
    func test_retrieve_emptyOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieveTwice: .empty)
    }
    
    func test_retrieveAfterInsertingCache_deliversInsertedValues() {
        let sut = makeSUT()
        let feed = uniqueItems().local
        let timestamp = Date()
        insert((feed, timestamp), to: sut)
        expect(sut, toRetrieve: .found(feed: feed, timestamp: timestamp))
    }
    
    func test_retrieve_deliversFailureOnRetrievalError() {
        let sut = makeSUT()
        try! "invalid data".write(to: testSpecificStoreUrl(), atomically: false, encoding: .utf8)
        expect(sut, toRetrieve: .failure(anyNSError()))
    }
    
    func test_retrieve_deliversFailureTwiceOnRetrievalError() {
        let sut = makeSUT()
        try! "invalid data".write(to: testSpecificStoreUrl(), atomically: false, encoding: .utf8)
        try! "invalid data".write(to: testSpecificStoreUrl(), atomically: false, encoding: .utf8)
        expect(sut, toRetrieveTwice: .failure(anyNSError()))
    }
    
    // ~ MARK: Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CodableFeedStore {
        let sut = CodableFeedStore(storeURL: testSpecificStoreUrl())
        trackForMemoryLeaks (sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: CodableFeedStore, toRetrieveTwice expectedResult:
                        RetrieveResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    private func expect(_ sut: CodableFeedStore, toRetrieve expectedResult:
                        RetrieveResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty):
                break
            case let (.found(expected), .found(retrieved)):
                XCTAssertEqual(retrieved.feed, expected.feed, file: file, line: line)
                XCTAssertEqual(retrieved.timestamp, expected.timestamp, file: file, line: line)
            case let (.failure(expected), .failure(retrieved)):
                XCTAssertEqual((retrieved as NSError).code, (expected as NSError).code, file: file, line: line)
                XCTAssertEqual((retrieved as NSError).domain, (expected as NSError).domain, file: file, line: line)
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead",
                        file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func insert(_
    cache: (feed: [LocalFeedItem], timestamp: Date), to sut:
                        CodableFeedStore) {
        let exp = expectation(description: "Wait for cache insertion" )
        sut.insert(cache.feed, timestamp: cache.timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected feed to be inserted successfully")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func testSpecificStoreUrl() -> URL {
        return FileManager.default.urls(for: .cachesDirectory,
        in: .userDomainMask).first!.appendingPathComponent ("\(type(of: self)).store")
    }
    
}
