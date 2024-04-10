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
        
        XCTAssertEqual(app.cells.count, 22)
        XCTAssertEqual(app.cells.firstMatch.images.count, 1)
    }
}
