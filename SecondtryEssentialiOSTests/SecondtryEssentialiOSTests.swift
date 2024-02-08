//
//  SecondtryEssentialiOSTests.swift
//  SecondtryEssentialiOSTests
//
//  Created by Amir on 2/8/24.
//

import XCTest

class FeedViewController: UIViewController {
    convenience init(loader: FeedViewControllerTests.LoaderSpy) {
        self.init()
    }
}

final class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)
        XCTAssertEqual(loader.localCallCount, 0)
    }
    
    // MARK: - Healpers
    class LoaderSpy {
        private(set) var localCallCount: Int = 0
    }
}


