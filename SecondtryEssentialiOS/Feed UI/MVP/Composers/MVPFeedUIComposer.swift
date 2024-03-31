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
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader:
                        MainQueueDispatchDecorator(decoratee: feedLoader))
        
        let feedController = makeFeedViewController(
            delegate: presentationAdapter,
            title: MVPFeedPresenter.title)
        
        presentationAdapter.presenter = MVPFeedPresenter(
            feedView: FeedViewAdapter(
                controller: feedController,
                imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)),
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
