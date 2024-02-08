//
//  SecondtryEssentialiOSTests.swift
//  SecondtryEssentialiOSTests
//
//  Created by Amir on 2/8/24.
//

import XCTest

class FeedViewController: UIViewController {
    private var loader: FeedViewControllerTests.LoaderSpy?
    convenience init(loader: FeedViewControllerTests.LoaderSpy) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader?.load()
    }
}

final class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)
        XCTAssertEqual(loader.localCallCount, 0)
    }
    
    func test_viewDidLoad_loadsFeed() {
        let loader = LoaderSpy()
        let viewController = FeedViewController(loader: loader)
        viewController.loadViewIfNeeded()
        XCTAssertEqual(loader.localCallCount, 1)
    }
    
    // MARK: - Healpers
    class LoaderSpy {
        private(set) var localCallCount: Int = 0
        
        func load() {
            localCallCount += 1
        }
    }
}


