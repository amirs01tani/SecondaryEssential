//
//  FeedLoaderCacheDecoratorTests.swift
//  SecondEssentialAppTests
//
//  Created by Amir on 4/2/24.
//

import XCTest
import SecondtryEssential

final class FeedLoaderCacheDecorator: FeedLoader {
    private let decoratee: FeedLoader

    init(decoratee: FeedLoader) {
        self.decoratee = decoratee
    }

    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load(completion: completion)
    }
}

class FeedLoaderCacheDecoratorTests: XCTestCase, FeedLoaderTestCase {

    func test_load_deliversFeedOnLoaderSuccess() {
        let feed = uniqueFeed()
        let loader = makeSUT(loaderResult: .success(feed))
        let sut = FeedLoaderCacheDecorator(decoratee: loader)

        expect(sut, toCompleteWith: .success(feed))
    }

    func test_load_deliversErrorOnLoaderFailure() {
        let sut = makeSUT(loaderResult: .failure(anyNSError()))

        expect(sut, toCompleteWith: .failure(anyNSError()))
    }

    // MARK: - Helpers
    private func makeSUT(loaderResult: FeedLoader.Result, file: StaticString = #file, line: UInt = #line) -> FeedLoader {
        let loader = FeedLoaderStub(result: loaderResult)
        let sut = FeedLoaderCacheDecorator(decoratee: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

}
