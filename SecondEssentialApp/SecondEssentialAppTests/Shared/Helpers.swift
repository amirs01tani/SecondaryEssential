//
//  Helpers.swift
//  SecondEssentialAppTests
//
//  Created by Amir on 4/2/24.
//

import Foundation
import SecondtryEssential

func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }

func anyURL() -> URL {
    return URL(string: "http://a-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func uniqueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID(), description: "any", location: "any", imageURL: anyURL())]
}
