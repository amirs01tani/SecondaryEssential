//
//  SceneDelegate.swift
//  SecondEssentialApp
//
//  Created by Amir on 3/31/24.
//

import UIKit
import SecondtryEssential
import SecondtryEssentialiOS
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        let remoteURL = URL(string:
        "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        
        let remoteClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let remoteFeedLoader = RemoteFeedLoader (url: remoteURL, client:
        remoteClient)
        let remoteImageLoader = RemoteFeedImageDataLoader (client: remoteClient)
        let localStoreURL = NSPersistentContainer.defaultDirectoryURL()
            .appendingPathComponent("feed-store.sqlite")
        let localStore = try! CoreDataFeedStore(storeURL: localStoreURL)
        let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
        let localImageLoader = LocalFeedImageDataLoader(store: localStore)
        window?.rootViewController = MVPFeedUIComposer.feedComposedWith(
            feedLoader:
                FeedLoaderWithFallbackComposite(
                primary: FeedLoaderCacheDecorator(decoratee: remoteFeedLoader, cache: localFeedLoader),
                fallback: localFeedLoader),
            imageLoader:
                FeedImageDataLoaderWithFallbackComposite(
                    primary: FeedImageDataLoaderCacheDecorator(decoratee: remoteImageLoader, cache: localImageLoader),
                    fallback: localImageLoader))
        
        
    }

}

