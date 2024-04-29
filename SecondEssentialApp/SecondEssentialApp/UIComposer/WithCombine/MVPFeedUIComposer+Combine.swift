//
//  FeedUIComposers.swift
//  SecondtryEssentialiOS
//
//  Created by Amir on 2/11/24.
//

import Foundation
import UIKit
import SecondtryEssential
import SecondtryEssentialiOS
import Combine

public final class MVPFeedUIComposerWithCombine {
    private init() {}

    public static func feedComposedWith(feedLoader: @escaping () -> FeedLoader.Publisher, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) -> MVPFeedViewController {
            let presentationAdapter = FeedLoaderPresentationAdapterWithCombine(
                feedLoader: { feedLoader() })
        
        let feedController = makeFeedViewController(
            delegate: presentationAdapter,
            title: MVPFeedPresenter.title)
        
        presentationAdapter.presenter = MVPFeedPresenter(
            feedView: FeedViewAdapterWithCombine(
                controller: feedController,
                imageLoader: imageLoader ),
            loadingView: WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController))
        
        return feedController
    }
    
    private static func makeFeedViewController(delegate: FeedViewControllerDelegate, title: String) -> MVPFeedViewController {
        let bundle = Bundle(for: MVPFeedViewController.self)
        let storyboard = UIStoryboard(name: "MVPFeed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! MVPFeedViewController
        feedController.delegate = delegate
        feedController.title = title
        return feedController
    }
}
