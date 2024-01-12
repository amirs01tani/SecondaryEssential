//
//  TestHelpers.swift
//  SecondtryEssentialTests
//
//  Created by Amir on 12/29/23.
//

import Foundation
import SecondtryEssential

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "", code: 1)
}

var uniqueItem: FeedItem {
    return FeedItem(id: UUID.init(), imageURL: anyURL())
}

func uniqueItems() -> (models: [FeedItem], local: [LocalFeedItem]) {
    let models = [uniqueItem, uniqueItem]
    let
    local = models.map { LocalFeedItem(id: $0.id, description: $0.description, location:
                                        $0.location, imageURL: $0.imageURL) }
    return (models, local)
}
