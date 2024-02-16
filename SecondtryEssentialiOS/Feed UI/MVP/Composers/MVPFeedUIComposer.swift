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
        let presenter = MVPFeedPresenter(feedLoader: feedLoader)
        let refreshController = MVPFeedRefreshViewController(loadFeed: presenter.loadFeed)
        let feedController = MVPFeedViewController(refreshController: refreshController)
        presenter.loadingView = WeakRefVirtualProxy(refreshController)
        presenter.feedView = MVPFeedViewAdapter(controller: feedController, imageLoader: imageLoader)
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

