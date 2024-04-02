//
//  FeedImageDataCache.swift
//  SecondtryEssential
//
//  Created by Amir on 3/31/24.
//

import Foundation

public protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
