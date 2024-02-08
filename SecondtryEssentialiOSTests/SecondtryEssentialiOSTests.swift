//
//  SecondtryEssentialiOSTests.swift
//  SecondtryEssentialiOSTests
//
//  Created by Amir on 2/8/24.
//

import XCTest
import SecondtryEssential

class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        refreshControl?.beginRefreshing()
        load()
    }
    
    @objc private func load() {
        loader?.load { _ in
        }
    }
}

final class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let (_, loader) = makeSUT()
        XCTAssertEqual(loader.localCallCount, 0)
    }
    
    func test_viewDidLoad_loadsFeed() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.localCallCount, 0)
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        XCTAssertEqual(loader.localCallCount, 1)
    }
    
    func test_pullToResfresh_loadsFields() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.localCallCount, 0)
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        XCTAssertEqual(loader.localCallCount, 1)
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        XCTAssertEqual(loader.localCallCount, 2)
    }
    
    func test_viewDidLoad_showsLoadingIndicator() {
        let (sut, _) = makeSUT()
        sut.simulateAppearance()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
    }
    
    // MARK: - Healpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    class LoaderSpy: FeedLoader {
        
        private(set) var localCallCount: Int = 0
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            localCallCount += 1
        }
        
    }
}


extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

extension FeedViewController {
    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
            replaceRefreshControlWithFakeForiOS17Support()
        }
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
    
    func replaceRefreshControlWithFakeForiOS17Support () {
        let fake = FakeRefreshControl()
        refreshControl?.allTargets.forEach { target in
            refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                action in fake.addTarget (target, action: Selector(action), for: .valueChanged)
            }
        }
        refreshControl = fake
    }
}

private class FakeRefreshControl: UIRefreshControl {
    private var _isRefreshing = false
    override var isRefreshing: Bool {
        _isRefreshing }
    override func beginRefreshing() {
        _isRefreshing = true
    }
    override func endRefreshing() {
        _isRefreshing = false
    }
}
