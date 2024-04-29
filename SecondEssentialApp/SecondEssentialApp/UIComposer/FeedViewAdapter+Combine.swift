//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import UIKit
import SecondtryEssential
import SecondtryEssentialiOS
import Combine

final class FeedViewAdapterWithCombine: FeedView {
	private weak var controller: MVPFeedViewController?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
	
    init(controller: MVPFeedViewController, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
		self.controller = controller
		self.imageLoader = imageLoader
	}
	
	func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map { model in
			let adapter = FeedImageDataLoaderPresentationAdapterWithCombine<WeakRefVirtualProxy<MVPFeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
			let view = MVPFeedImageCellController(delegate: adapter)
			
			adapter.presenter = MVPFeedImagePresenter(
				view: WeakRefVirtualProxy(view),
				imageTransformer: UIImage.init)
			
			return view
		})
	}
}
