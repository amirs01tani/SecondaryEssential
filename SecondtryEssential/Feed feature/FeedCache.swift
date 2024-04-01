//
//  FeedCache.swift
//  SecondtryEssential
//
//  Created by Amir on 4/2/24.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
