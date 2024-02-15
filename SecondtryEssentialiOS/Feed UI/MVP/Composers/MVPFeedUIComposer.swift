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
        let refreshController = MVPFeedRefreshViewController(presenter: presenter)
        let feedController = MVPFeedViewController(refreshController: refreshController)
        presenter.loadingView = refreshController
        presenter.feedView = FeedViewAdapter(controller: feedController, imageLoader: imageLoader)
        return feedController
    }
    
}

private final class FeedViewAdapter: FeedView {
    private weak var controller: MVPFeedViewController?
    private let imageLoader: FeedImageDataLoader
    
    init(controller: MVPFeedViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }

    func display(feed: [FeedImage]) {
        controller?.tableModel = feed.map { model in
            MVPFeedImageCellController(viewModel:
                MVPFeedImageViewModel(model: model, imageLoader: imageLoader, imageTransformer: UIImage.init))
        }
    }
}
