//
//  SceneDelegateTests.swift
//  SecondEssentialAppTests
//
//  Created by Amir on 4/11/24.
//

import XCTest
import SecondtryEssentialiOS
@testable import SecondEssentialApp

class SceneDelegateTests: XCTestCase {

    func test_configureWindow_setsWindowAsKeyAndVisible() {
        let window = UIWindow()
        let sut = SceneDelegate()
        sut.window = window
        
        sut.configureWindow()
        
        XCTAssertFalse(window.isHidden, "Expected window to be visible")
    }
    
    func test_sceneWillConnectToSession_configuresRootViewController() {
        let sut = SceneDelegate()
        sut.window = UIWindow()

        sut.configureWindow()

        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController

        XCTAssertNotNil(rootNavigation, "Expected a navigation controller as root, got \(String(describing: root)) instead")
        XCTAssertTrue(topController is MVPFeedViewController, "Expected a feed controller as top view controller, got \(String(describing: topController)) instead")
    }

}
