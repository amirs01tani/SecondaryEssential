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
    var refreshControl: UIRefreshControl?
    
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    @objc func load() {
        loader?.load { _ in }
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
        XCTAssertEqual(loader.localCallCount, 1)
    }
    
    func test_pullToResfresh_loadsFields() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        sut.refreshControl?.allTargets.forEach { target in
            sut.refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
        XCTAssertEqual(loader.localCallCount, 2)
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


