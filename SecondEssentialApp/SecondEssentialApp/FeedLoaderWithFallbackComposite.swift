//
//  FeedLoaderWithFallbackComposite.swift
//  SecondEssentialApp
//
//  Created by Amir on 4/1/24.
//

import Foundation
import SecondtryEssential

public class FeedLoaderWithFallbackComposite: FeedLoader {
    private let primary: FeedLoader
    private let fallback: FeedLoader

    public init(primary: FeedLoader, fallback: FeedLoader) {
        self.primary = primary
        self.fallback = fallback
    }

    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        primary.load() { [weak self] result in
            switch result {
            case .success(let images):
                completion(.success(images))
            case .failure( _):
                self?.fallback.load(completion: completion)
            }
        }
    }
}
