//
//  MVVMFeedViewModel.swift
//  SecondtryEssentialiOS
//
//  Created by Amir on 2/15/24.
//
import Foundation
import SecondtryEssential

// stateless View Model Version
final class MVVMFeedViewModel {
    typealias Observer<T> = (T) -> Void
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onLoadingStateChange: Observer<Bool>?
    var onFeedLoad: Observer<[FeedImage]>?
    
    func loadFeed() {
        self.onLoadingStateChange?(true)
        feedLoader.load { [weak self] result in
            guard let self else { return }
            if let feed = try? result.get() {
                self.onFeedLoad?(feed)
            } else {
                self.onLoadingStateChange?(false)
            }
        }
    }
}


// stateful view model version
//final class MVVMFeedViewModel {
//    private let feedLoader: FeedLoader
//
//    init(feedLoader: FeedLoader) {
//        self.feedLoader = feedLoader
//    }
//
////    private enum State {
////        case pending
////        case loading
////        case loaded ([FeedImage])
////        case failed
////    }
////    private var state = State.pending {
////        didSet { onChange?(self) }
////    }
//
//    var onLoadingStateChange: ((MVVMFeedViewModel) -> Void)?
//    var onFeedLoad: (([FeedImage]) -> Void)?
//    // holding the state does not have to
//    var isLoading: Bool = false {
//        didSet { onLoadingStateChange?(self) }
//    }
//
//    func loadFeed() {
//        feedLoader.load { [weak self] result in
//            guard let self else { return }
//            if let feed = try? result.get() {
//                self.onFeedLoad?(feed)
//            } else {
//                self.onLoadingStateChange?(self)
//            }
//        }
//    }
//
////    var isLoading: Bool {
////        switch state {
////        case .loading:
////            return true
////        default:
////            return false
////        }
////    }
////
////    var feed: [FeedImage]? {
////        switch state {
////        case .loaded(let feed):
////            return feed
////        default:
////            return nil
////        }
////    }
//}
