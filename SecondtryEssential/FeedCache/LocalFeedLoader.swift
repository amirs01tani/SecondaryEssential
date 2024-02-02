//
//  LocalFeedLoader.swift
//  SecondtryEssential
//
//  Created by Amir on 1/12/24.
//

import Foundation

public class LocalFeedLoader: FeedLoader {
    
    public let store: FeedStore
    public let currentDate: () -> Date
    
    public typealias SaveResult = Result<Void, Error>
    public typealias LoadResult = FeedLoader.Result
    
    public init(store: FeedStore, currentDate: @escaping () -> Date){
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ items: [FeedItem], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed() { [weak self] deletionResult in
            guard let self else { return }
            switch deletionResult {
            case .success:
                self.cache(items, completion: completion)
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        store.retrieve { [weak self] data in
            guard let self else { return }
            switch data {
            case .failure(let error):
                completion(.failure(error))
            case let .success(.some(cache)) where CachePolicy.validate(cache.timestamp, against: currentDate()):
                completion(.success(cache.feed.toModels()))
            case .success:
                completion(.success([]))
            }
        }
    }
    
    public func validateCache() {
        store.retrieve() { [weak self] result in
            switch result {
            case .failure:
                self?.store.deleteCachedFeed() { _ in }
            default:
                break
            }
        }
    }
    
    public func cache(_ items: [FeedItem], completion: @escaping (SaveResult) -> Void) {
        self.store.insert(items.toLocal(), timestamp: self.currentDate(), completion: { insertionResult in
            completion(insertionResult)
        })
    }
}

private extension Array where Element == FeedItem {
    func toLocal() -> [LocalFeedItem] {
        return map { LocalFeedItem(id: $0.id, description: $0.description, location: $0.location,
                                   imageURL: $0.imageURL) }
    }
}

private extension Array where Element == LocalFeedItem {
    func toModels() -> [FeedItem] {
        return map { FeedItem(id: $0.id, description: $0.description, location: $0.location, imageURL: $0.imageURL) }
    }
}
