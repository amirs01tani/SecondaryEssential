//
//  CodableFeedStoreTests.swift
//  SecondtryEssentialTests
//
//  Created by Amir on 1/19/24.
//

import Foundation
import XCTest
import SecondtryEssential

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
        let sut = makeSUT(storeURL: testSpecificStoreUrl())
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT(storeURL: testSpecificStoreUrl())
        
        expect(sut, toRetrieveTwice: .empty)
    }
    
    func test_retrieveAfterInsertingCache_deliversInsertedValues() {
        let sut = makeSUT(storeURL: testSpecificStoreUrl())
        let feed = uniqueItems().local
        let timestamp = Date()
        insert((feed, timestamp), to: sut)
        expect(sut, toRetrieve: .found(feed: feed, timestamp: timestamp))
    }
    
    func test_retrieve_deliversFailureOnRetrievalError() {
        let sut = makeSUT(storeURL: testSpecificStoreUrl())
        try! "invalid data".write(to: testSpecificStoreUrl(), atomically: false, encoding: .utf8)
        expect(sut, toRetrieve: .failure(anyNSError()))
    }
    
    func test_retrieve_deliversFailureTwiceOnRetrievalError() {
        let sut = makeSUT(storeURL: testSpecificStoreUrl())
        try! "invalid data".write(to: testSpecificStoreUrl(), atomically: false, encoding: .utf8)
        try! "invalid data".write(to: testSpecificStoreUrl(), atomically: false, encoding: .utf8)
        expect(sut, toRetrieveTwice: .failure(anyNSError()))
    }
    
    func test_insert_overridesPreviouslyInsertedCachedValues() {
        let sut = makeSUT(storeURL: testSpecificStoreUrl())
        let firstFeed = uniqueItems().local
        let secondFeed = uniqueItems().local
        let timestamp = Date()
        insert((firstFeed, timestamp), to: sut)
        expect(sut, toRetrieve: .found(feed: firstFeed, timestamp: timestamp))
        
        insert((secondFeed, timestamp), to: sut)
        expect(sut, toRetrieve: .found(feed: secondFeed, timestamp: timestamp))
    }
    
    func test_insert_deliversErrorOnInsertionError() {
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)
        let feed = uniqueItems().local
        let timestamp = Date()
        
        let insertionError = insert((feed, timestamp), to: sut)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error")
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        let deletionError = deleteCache(from: sut)
        XCTAssertNil (deletionError,
                      "Expected empty cache deletion to succeed")
        expect(sut, toRetrieve: .empty)
    }
    
    func test_delete_emptiesPreviouslyInsertedCache () {
        let sut = makeSUT()
        insert ((uniqueItems().local, Date()), to: sut)
        let deletionError = deleteCache(from: sut)
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")
        expect (sut, toRetrieve: .empty)
    }
    
    func test_delete_deliversError0nDeletionError () {
        let noDeletePermissionURL = cachesDirectory()
        let sut = makeSUT(storeURL: noDeletePermissionURL)
        let deletionError = deleteCache(from: sut)
        XCTAssertNotNil(deletionError, "Expected cache deletion to fail")
    }
    
    // ~ MARK: Helpers
    
    private func makeSUT(storeURL: URL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent ("CodableFeedStoreTests)).store"), file: StaticString = #file, line: UInt = #line) -> FeedStore {
        let sut = CodableFeedStore(storeURL: storeURL)
        trackForMemoryLeaks (sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: FeedStore, toRetrieveTwice expectedResult:
                        RetrieveResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    private func expect(_ sut: FeedStore, toRetrieve expectedResult:
                        RetrieveResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty):
                break
            case let (.found(expected), .found(retrieved)):
                XCTAssertEqual(retrieved.feed, expected.feed, file: file, line: line)
                XCTAssertEqual(retrieved.timestamp, expected.timestamp, file: file, line: line)
            case (.failure, .failure):
                break
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead",
                        file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    @discardableResult
    private func insert(_
    cache: (feed: [LocalFeedItem], timestamp: Date), to sut:
                        FeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache insertion" )
        var insertionError: Error?
        sut.insert(cache.feed, timestamp: cache.timestamp) { receivedInsertionError in
            insertionError = receivedInsertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    private func deleteCache(from sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache insertion" )
        var deletionError: Error?
        sut.deleteCachedFeed(){ receivedDeletionError in
            deletionError = receivedDeletionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return deletionError
    }
    
    private func testSpecificStoreUrl() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
}
