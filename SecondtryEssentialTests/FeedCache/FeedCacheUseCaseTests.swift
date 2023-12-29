//
//  FeedCacheUseCaseTests.swift
//  SecondtryEssentialTests
//
//  Created by Amir on 12/29/23.
//

import XCTest

class LocalFeedLoader{
    let store: FeedStore
    init(store: FeedStore){
        self.store = store
    }
    
    func save() {
        store.deleteCachedFeed()
    }
}

class FeedStore{
    var deleteCacheFeedCallCount = 0
    
    func deleteCachedFeed() {
        deleteCacheFeedCallCount += 1
    }
}

final class FeedCacheUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheUnderCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.deleteCacheFeedCallCount, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        sut.save()
        XCTAssertEqual(store.deleteCacheFeedCallCount, 1)
    }
}



// MARK: - Helpers
private func makeSUT() -> (sut: LocalFeedLoader, store: FeedStore){
    let store = FeedStore()
    let sut = LocalFeedLoader(store: store)
    return (sut, store)
}
