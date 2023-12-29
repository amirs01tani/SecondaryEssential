//
//  FeedCacheUseCaseTests.swift
//  SecondtryEssentialTests
//
//  Created by Amir on 12/29/23.
//

import XCTest

class LocalFeedLoader{
    init(store: FeedStore){
        
    }
}

class FeedStore{
    var deleteCacheFeedCallCount = 0
}

final class FeedCacheUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheUnderCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.deleteCacheFeedCallCount, 0)
    }
}

// MARK: - Helpers
private func makeSUT() -> (sut: LocalFeedLoader, store: FeedStore){
    let store = FeedStore()
    let sut = LocalFeedLoader(store: store)
    return (sut, store)
}
