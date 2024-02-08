//
//  SecondtryEssentialiOSTests.swift
//  SecondtryEssentialiOSTests
//
//  Created by Amir on 2/8/24.
//

import XCTest
import SecondtryEssential

class FeedViewController: UIViewController {
    private var loader: FeedLoader?
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader?.load { _ in }
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
    class LoaderSpy: FeedLoader {
        
        private(set) var localCallCount: Int = 0
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            localCallCount += 1
        }
        
    }
}


