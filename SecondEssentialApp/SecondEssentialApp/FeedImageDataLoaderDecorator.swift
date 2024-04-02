//
//  FeedImageDataLoaderDecorator.swift
//  SecondEssentialApp
//
//  Created by Amir on 4/2/24.
//

import Foundation
import SecondtryEssential

public class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    private let decoratee: FeedImageDataLoader
    private let cache: FeedImageDataCache

    public init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }

    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = decoratee.loadImageData(from: url) { [weak self] result in
            completion(result.map { data in
                self?.cache.save(data, for: url) { _ in }
                return data
            })
            //            if let data = (try? result.get()) {
            //                self?.cache.save(data, for: url) { _ in }
            //            }
            //            completion(result)
        }
        return task
    }
}
