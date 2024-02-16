//
//  FeedUIComposers.swift
//  SecondtryEssentialiOS
//
//  Created by Amir on 2/11/24.
//

import Foundation
import UIKit
import SecondtryEssential

public final class MVPFeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> MVPFeedViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: feedLoader)
        let refreshController = MVPFeedRefreshViewController(delegate: presentationAdapter)
        let feedController = MVPFeedViewController(refreshController: refreshController)
        presentationAdapter.presenter = MVPFeedPresenter(
            feedView: MVPFeedViewAdapter(controller: feedController, imageLoader: imageLoader),
            loadingView: WeakRefVirtualProxy(refreshController))
        
        return feedController
    }
    
}

private final class MVPFeedViewAdapter: FeedView {
    
    private weak var controller: MVPFeedViewController?
    private let imageLoader: FeedImageDataLoader
    
    init(controller: MVPFeedViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }

    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map { model in
            MVPFeedImageCellController(viewModel:
                MVPFeedImageViewModel(model: model, imageLoader: imageLoader, imageTransformer: UIImage.init))
        }
    }
}

private final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?

    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel) {
        object?.display(viewModel)
    }
}


private final class FeedLoaderPresentationAdapter: FeedRefreshViewControllerDelegate {
    
    private let feedLoader: FeedLoader
    var presenter: MVPFeedPresenter?

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()

        feedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.presenter?.didFinishLoadingFeed(with: feed)

            case let .failure(error):
                self?.presenter?.didFinishLoadingFeed(with: error)
            }
        }
    }
}
