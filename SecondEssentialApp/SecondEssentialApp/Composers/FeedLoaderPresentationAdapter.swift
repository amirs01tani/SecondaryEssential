//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import SecondtryEssential
import SecondtryEssentialiOS

final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {
    
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
