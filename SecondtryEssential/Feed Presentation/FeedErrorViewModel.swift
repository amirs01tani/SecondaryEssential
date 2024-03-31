//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

public struct FeedErrorViewModel {
	public let message: String?
	
	public static var noError: FeedErrorViewModel {
		return FeedErrorViewModel(message: nil)
	}
	
	public static func error(message: String) -> FeedErrorViewModel {
		return FeedErrorViewModel(message: message)
	}
}
