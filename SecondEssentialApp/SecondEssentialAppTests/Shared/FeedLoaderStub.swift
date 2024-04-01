//
//  FeedLoaderStub.swift
//  SecondEssentialAppTests
//
//  Created by Amir on 4/2/24.
//

import SecondtryEssential

class FeedLoaderStub: FeedLoader {
    let result: FeedLoader.Result

    init(result: FeedLoader.Result) {
        self.result = result
    }

    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
