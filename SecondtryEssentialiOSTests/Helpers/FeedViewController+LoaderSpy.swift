//
//  FeedViewController+LoaderSpy.swift
//  SecondtryEssentialiOSTests
//
//  Created by Amir on 2/11/24.
//

import Foundation
import SecondtryEssential
import SecondtryEssentialiOS

class LoaderSpy: FeedLoader, FeedImageDataLoader {
    
    private var feedRequesrs = [(FeedLoader.Result) -> Void]()
    
    var loadFeedCallCount: Int {
        return feedRequesrs.count
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        feedRequesrs.append(completion)
    }
    
    func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
        feedRequesrs[index](.success(feed))
    }
    
    func completeFeedLoadingWithError(at index: Int = 0) {
        let error = NSError(domain: "an error", code: 0)
        feedRequesrs[index](.failure(error))
    }
    
    // MARK: - FeedImageDataLoader
    private struct TaskSpy: FeedImageDataLoaderTask {
        let cancelCallback: () -> Void
        func cancel() {
            cancelCallback()
        }
    }
    private var imageRequests = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()

    var loadedImageURLs: [URL] {
        return imageRequests.map { $0.url }
    }
    private(set) var cancelledImageURLs = [URL]()
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
                imageRequests.append((url, completion))
                return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
            }
    
    func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
        imageRequests[index].completion(.success(imageData))
    }
    
    func completeImageLoadingWithError(at index: Int = 0) {
        let error = NSError(domain: "an error", code: 0)
        imageRequests[index].completion(.failure(error))
    }
}
