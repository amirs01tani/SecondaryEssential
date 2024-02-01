//
//  SecondtryEssentialFeedCacheIntegrationTests.swift
//  SecondtryEssentialFeedCacheIntegrationTests
//
//  Created by Amir on 2/1/24.
//

import XCTest
import SecondtryEssential

final class SecondtryEssentialFeedCacheIntegrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    func test_load_deliversNoItemsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toLoad: [])
    }
    
    func test_load_deliversItemsSavedOnASeparateInstance() {
        let sutToPerformSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let feed = uniqueItems()
        
        let saveExp = expectation(description: "Wait for save completion")
        sutToPerformSave.save(feed.local) { saveError in
            XCTAssertNil(saveError, "Expected to save feed successfully")
            saveExp.fulfill()
        }
        wait(for: [saveExp], timeout: 1.0)
        
        expect(sutToPerformLoad, toLoad: feed.models)
    }
    
    // MARK: Helpers
    
    private func expect(_ sut: LocalFeedLoader, toLoad expectedFeed: [FeedItem], file: StaticString = #file, line: UInt = #line) {
            let exp = expectation(description: "Wait for load completion")
            sut.load { result in
                switch result {
                case let .success(loadedFeed):
                    XCTAssertEqual(loadedFeed, expectedFeed, file: file, line: line)

                case let .failure(error):
                    XCTFail("Expected successful feed result, got \(error) instead", file: file, line: line)
                }

                exp.fulfill()
            }
            wait(for: [exp], timeout: 1.0)
        }

    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocalFeedLoader {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
        let sut = LocalFeedLoader(store: store, currentDate: Date.init)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    
    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
}
