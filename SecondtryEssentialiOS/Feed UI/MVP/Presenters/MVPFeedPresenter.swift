//
//  MVVMFeedViewModel.swift
//  SecondtryEssentialiOS
//
//  Created by Amir on 2/15/24.
//
import Foundation
import SecondtryEssential

protocol FeedLoadingView: AnyObject {
    func display(isLoading: Bool)
}

protocol FeedView {
    func display(feed: [FeedImage])
}

final class MVPFeedPresenter {
    typealias Observer<T> = (T) -> Void

    private let feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    var feedView: FeedView?
    weak var loadingView: FeedLoadingView?

    func loadFeed() {
        loadingView?.display(isLoading: true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(feed: feed)
            }
            self?.loadingView?.display(isLoading: false)
        }
    }
}
