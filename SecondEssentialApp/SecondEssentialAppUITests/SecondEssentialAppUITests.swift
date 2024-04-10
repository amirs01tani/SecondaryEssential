//
//  SecondEssentialAppUITests.swift
//  SecondEssentialAppUITests
//
//  Created by Amir on 3/31/24.
//

import XCTest

final class SecondEssentialAppUITests: XCTestCase {
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let app = XCUIApplication()
        
        app.launch()
    
        let feedCells = app.cells.matching(identifier: "feed-image-cell")
        XCTAssertEqual(feedCells.count, 22)
        
        let firstImage = app.images.matching(identifier: "feed-image-view").firstMatch
        XCTAssertTrue(firstImage.exists)
        
    }
}
