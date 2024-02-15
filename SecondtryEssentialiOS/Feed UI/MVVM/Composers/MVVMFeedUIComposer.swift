//
//  FeedUIComposers.swift
//  SecondtryEssentialiOS
//
//  Created by Amir on 2/11/24.
//

import Foundation
import UIKit
import SecondtryEssential

public final class MVVMFeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> MVVMFeedViewController {
        let viewModel = MVVMFeedViewModel(feedLoader: feedLoader)
        let refreshController = MVVMFeedRefreshViewController(viewModel: viewModel)
        let feedController = MVVMFeedViewController(refreshController: refreshController)
        refreshController.onRefresh = adaptFeedToCellControllers(forwardingTo: feedController, loader: imageLoader)
        return feedController
    }
    
    private static func adaptFeedToCellControllers(forwardingTo controller: MVVMFeedViewController, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
        return { [weak controller] feed in
            controller?.tableModel = feed.map { model in
                MVVMFeedImageCellController(model: model, imageLoader: loader)
            }
        }
    }
    
}
