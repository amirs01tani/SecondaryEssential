//
//  FeedLoader.swift
//  SecondtryEssential
//
//  Created by Amir on 3/31/24.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    func load(completion: @escaping (Result) -> Void)
}
