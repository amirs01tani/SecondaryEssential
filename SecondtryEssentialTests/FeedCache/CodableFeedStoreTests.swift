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
    let feedStore = FeedStoreSpy()
    func retrieve(completion: @escaping (RetrieveResult) -> ()) {
        feedStore.retrieve(completion: completion)
        feedStore.completeRetrievalWithEmptyCache()
    }
}

class CodableFeedStoreTests: XCTestCase {
    
    func test_retrieve_emptyOnEmptyCache() {
        let sut = CodableFeedStore()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { receivedResult in
            switch receivedResult {
            case .empty:
                break
            default:
                XCTFail("Expected empty result but received \(receivedResult)")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
}
