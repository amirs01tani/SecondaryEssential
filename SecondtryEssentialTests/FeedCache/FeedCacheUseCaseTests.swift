//
//  FeedCacheUseCaseTests.swift
//  SecondtryEssentialTests
//
//  Created by Amir on 12/29/23.
//

import XCTest
import SecondtryEssential

class LocalFeedLoader{
    let store: FeedStore
    let currentDate: () -> Date
    init(store: FeedStore, currentDate: @escaping () -> Date){
        self.store = store
        self.currentDate = currentDate
    }
    
    func save(_ items: [FeedItem], completion: @escaping (Error?) -> Void) {
        store.deleteCachedFeed() { [weak self] error in
            guard let self else { return }
            if error == nil {
                self.store.insert(items, timestamp: self.currentDate(), completion: completion)
            } else {
                completion(error!)
            }
        }
    }
}

class FeedStore {
    typealias ErrorCompletion = (Error?) -> Void
    var deletionCompletions = [ErrorCompletion]()
    var insertCompletions = [ErrorCompletion]()
    var insertions = [(items: [FeedItem], timestamp: Date)]()
    
    func deleteCachedFeed(completion: @escaping ErrorCompletion) {
        deletionCompletions.append(completion)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping ErrorCompletion) {
        insertions.append((items: items, timestamp: timestamp))
        insertCompletions.append(completion)
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertCompletions[index](nil)
    }
    
}

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
        let items = [uniqueItem, uniqueItem]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        sut.save(items) { _ in }
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.insertions.count, 0)
    }
    
    func test_save_requestNewCacheInsertionOnSuccessfulDeletion() {
        let items = [uniqueItem, uniqueItem]
        let (sut, store) = makeSUT()
        
        sut.save(items) { _ in }
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.insertions.count, 1)
    }
    
    func test_save_requestNewCacheInsertionWithTimeStampOnSuccessfulDeletion() {
        let timestamp = Date()
        let items = [uniqueItem, uniqueItem]
        let (sut, store) = makeSUT(currentDate: { timestamp })
        
        sut.save(items) { _ in }
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.insertions.count, 1)
        XCTAssertEqual(store.insertions.first?.items, items)
        XCTAssertEqual(store.insertions.first?.timestamp, timestamp)
    }
    
    func test_save_failsOnDeletionError() {
        let items = [uniqueItem, uniqueItem]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        let exp = expectation(description: "Wait for save completion")
        var receivedError: Error?
        sut.save(items) { error in
            receivedError = error
            exp.fulfill()
        }
        store.completeDeletion(with: deletionError)
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedError as NSError?, deletionError)
    }
    
    func test_save_failsOnInsertionError() {
        let items = [uniqueItem, uniqueItem]
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        let exp = expectation(description: "Wait for save completion")
        var receivedError: Error?
        sut.save(items) { error in
            receivedError = error
            exp.fulfill()
        }
        store.completeDeletionSuccessfully(at: 0)
        store.completeInsertion(with: insertionError)
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedError as NSError?, insertionError)
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let items = [uniqueItem, uniqueItem]
        let (sut, store) = makeSUT()
        let exp = expectation(description:
                                "Wait for save completion")
        var receivedError: Error?
        
        sut.save(items) { error in
            receivedError = error
            exp.fulfill()
        }
        store.completeDeletionSuccessfully()
        store.completeInsertionSuccessfully()
        wait(for: [exp], timeout: 1.0)
        XCTAssertNil(receivedError)
    }
}





// MARK: - Helpers
private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore){
    let store = FeedStore()
    let sut = LocalFeedLoader(store: store, currentDate: currentDate)
    return (sut, store)
}

private var uniqueItem: FeedItem {
    return FeedItem(id: UUID.init(), imageURL: anyURL())
}
