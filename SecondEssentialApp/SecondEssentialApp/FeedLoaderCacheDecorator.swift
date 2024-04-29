//
//  FeedCache.swift
//  SecondEssentialApp
//
//  Created by Amir on 4/2/24.
//  redundant while using combine

import SecondtryEssential

public final class FeedLoaderCacheDecorator: FeedLoader {
    private let decoratee: FeedLoader
    let cache: FeedCache
    
    public init(decoratee: FeedLoader, cache: FeedCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
// mapping
            completion(result.map { feed in
                self?.cache.saveIgnoringResult(feed)
                return feed
            })
// if/try
//            if let result = try? result.get() {
//                self?.cache.save(result) { _ in }
//            }
//            completion(result)
        }
    }
}

private extension FeedCache {
    func saveIgnoringResult(_ feed: [FeedImage]) {
        save(feed) { _ in }
    }
}
