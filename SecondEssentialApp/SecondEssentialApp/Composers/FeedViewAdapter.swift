//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import UIKit
import SecondtryEssential
import SecondtryEssentialiOS

final class FeedViewAdapter: FeedView {
	private weak var controller: MVPFeedViewController?
	private let imageLoader: FeedImageDataLoader
	
	init(controller: MVPFeedViewController, imageLoader: FeedImageDataLoader) {
		self.controller = controller
		self.imageLoader = imageLoader
	}
	
	func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map { model in
			let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<MVPFeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
			let view = MVPFeedImageCellController(delegate: adapter)
			
			adapter.presenter = MVPFeedImagePresenter(
				view: WeakRefVirtualProxy(view),
				imageTransformer: UIImage.init)
			
			return view
		})
	}
}
