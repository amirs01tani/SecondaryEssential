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
    private let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("image-feed. store")
    
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
    
    func retrieve(completion: @escaping (RetrieveResult) -> ()) {
        guard let data = try? Data (contentsOf: storeURL) else { return completion(.empty) }
        
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
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = CodableFeedStore()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case (.empty, .empty):
                    break
                default:
                    XCTFail("Expected empty result for both empty caches but received \(firstResult) and \(secondResult)")
                }
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
}
