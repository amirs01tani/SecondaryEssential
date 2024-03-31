//
//  TestHelpers.swift
//  SecondtryEssentialTests
//
//  Created by Amir on 12/29/23.
//

import Foundation
import SecondtryEssential

func anyData() -> Data {
    return Data("any data".utf8)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "", code: 1)
}

var uniqueItem: FeedImage {
    return FeedImage(id: UUID.init(), imageURL: anyURL())
}

func uniqueItems() -> (models: [FeedImage], local: [LocalFeedItem]) {
    let models = [uniqueItem, uniqueItem]
    let
    local = models.map { LocalFeedItem(id: $0.id, description: $0.description, location:
                                        $0.location, imageURL: $0.url) }
    return (models, local)
}
