//
//  FeedImageDataCache.swift
//  SecondtryEssential
//
//  Created by Amir on 3/31/24.
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
