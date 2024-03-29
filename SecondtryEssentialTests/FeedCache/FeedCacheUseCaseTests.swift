//
//  FeedCacheUseCaseTests.swift
//  SecondtryEssentialTests
//
//  Created by Amir on 12/29/23.
//

import XCTest
import SecondtryEssential

final class FeedCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUnderCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.deletionCompletions.count, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        sut.save([]) { _ in }
        XCTAssertEqual(store.deletionCompletions.count, 1)
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let items = uniqueItems().models
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        sut.save(items) { _ in }
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages.count, 1)
    }
    
    func test_save_requestNewCacheInsertionOnSuccessfulDeletion() {
        let items = uniqueItems().models
        let (sut, store) = makeSUT()
        
        sut.save(items) { _ in }
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMessages.count, 2)
    }
    
    func test_save_requestNewCacheInsertionWithTimeStampOnSuccessfulDeletion() {
        let timestamp = Date()
        let items = uniqueItems()
        let (sut, store) = makeSUT(currentDate: { timestamp })
        
        sut.save(items.models) { _ in }
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMessages.count, 2)
        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed , .insert(items.local, timestamp)])
        
    }
    
    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        expect(sut, toCompleteWithError: deletionError, when: {
            store.completeDeletion(with: deletionError)
        })
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        expect(sut, toCompleteWithError: insertionError, when: {
            store.completeDeletionSuccessfully(at: 0)
            store.completeInsertion(with: insertionError)
        })
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWithError: nil, when: {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        })
    }
    
    func
    test_save_doesNotDeliverDeletionErrorAfterSUTInstanceHasBeenDeallocated() {
        
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader (store: store, currentDate: Date.init)
        var receivedResults = [Error?]()
        sut?.save(uniqueItems().models) { result in
            if case let Result.failure(error) = result { receivedResults.append(error)
            }
            sut = nil
            store.completeDeletion(with: anyNSError())
            XCTAssertTrue(receivedResults.isEmpty)
        }
    }
    
    
    // MARK: - Helpers
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy){
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalFeedLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")
        
        var receivedError: Error?
        sut.save(uniqueItems().models) { result in
            if case let Result.failure(error) = result { receivedError = error }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }
        
}
