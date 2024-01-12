//
//  LocalFeedLoader.swift
//  SecondtryEssential
//
//  Created by Amir on 1/12/24.
//

import Foundation

public typealias SaveResult = Error?

public class LocalFeedLoader{
    
    public enum LoadResult
    {
        case success([LocalFeedItem])
        case failure(Error?)
    }
    
    public let store: FeedStore
    public let currentDate: () -> Date
    
    public init(store: FeedStore, currentDate: @escaping () -> Date){
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ items: [LocalFeedItem], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed() { [weak self] error in
            guard let self else { return }
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                cache(items, completion: completion)
            }
        }
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success([]))
            }
        }
    }
    
    public func cache(_ items: [LocalFeedItem], completion: @escaping (SaveResult) -> Void) {
        self.store.insert(items, timestamp: self.currentDate(), completion: { error in
            completion(error)
        })
    }
}

private extension Array where Element == FeedItem {
    func toLocal() -> [LocalFeedItem] {
        return map { LocalFeedItem(id: $0.id, description: $0.description, location: $0.location,
            imageURL: $0.imageURL) }
    }
}
