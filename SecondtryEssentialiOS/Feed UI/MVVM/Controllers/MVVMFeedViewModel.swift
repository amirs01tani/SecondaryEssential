//
//  MVVMFeedViewModel.swift
//  SecondtryEssentialiOS
//
//  Created by Amir on 2/15/24.
//
// stateful view model
import Foundation
import SecondtryEssential

final class MVVMFeedViewModel {
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
//    private enum State {
//        case pending
//        case loading
//        case loaded ([FeedImage])
//        case failed
//    }
//    private var state = State.pending {
//        didSet { onChange?(self) }
//    }
    
    var onLoadingStateChange: ((MVVMFeedViewModel) -> Void)?
    var onFeedLoad: (([FeedImage]) -> Void)?
    
    var isLoading: Bool = false {
        didSet { onLoadingStateChange?(self) }
    }
    
    func loadFeed() {
        feedLoader.load { [weak self] result in
            guard let self else { return }
            if let feed = try? result.get() {
                self.onFeedLoad?(feed)
            } else {
                self.onLoadingStateChange?(self)
            }
        }
    }
    
//    var isLoading: Bool {
//        switch state {
//        case .loading:
//            return true
//        default:
//            return false
//        }
//    }
//    
//    var feed: [FeedImage]? {
//        switch state {
//        case .loaded(let feed):
//            return feed
//        default:
//            return nil
//        }
//    }
}
