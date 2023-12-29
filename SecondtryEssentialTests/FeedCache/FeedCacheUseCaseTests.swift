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
    init(store: FeedStore){
        self.store = store
    }
    
    func save(_ items: [FeedItem]) {
        store.deleteCachedFeed() { [weak self] error in
            if error == nil {
                self?.store.insert(items)
            }
        }
    }
}

class FeedStore {
    var deleteCacheFeedCallCount = 0
    var insertCallCount = 0
    typealias DeletionCompletion = (Error?) -> Void
    private var deletionCompletions = [DeletionCompletion]()
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deleteCacheFeedCallCount += 1
        deletionCompletions.append(completion)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func insert(_ items: [FeedItem]) {
        insertCallCount += 1
    }
}

final class FeedCacheUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheUnderCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.deleteCacheFeedCallCount, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        sut.save([])
        XCTAssertEqual(store.deleteCacheFeedCallCount, 1)
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let items = [uniqueItem, uniqueItem]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        sut.save(items)
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.insertCallCount, 0)
    }
    
    func test_save_requestNewCacheInsertionOnSuccessfulDeletion() {
        let items = [uniqueItem, uniqueItem]
        let (sut, store) = makeSUT()
        
        sut.save(items)
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.insertCallCount, 1)
    }
}



// MARK: - Helpers
private func makeSUT() -> (sut: LocalFeedLoader, store: FeedStore){
    let store = FeedStore()
    let sut = LocalFeedLoader(store: store)
    return (sut, store)
}

private var uniqueItem: FeedItem {
    return FeedItem(id: UUID.init(), imageURL: anyURL())
}
