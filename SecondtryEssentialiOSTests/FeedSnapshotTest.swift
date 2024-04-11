//
//  FeedSnapshotTest.swift
//  SecondtryEssentialiOSTests
//
//  Created by Amir on 4/11/24.
//


import XCTest
import SecondtryEssentialiOS

class FeedSnapshotTests: XCTestCase {

    func test_emptyFeed() {
        let sut = makeSUT()

        sut.display(emptyFeed())

        record(snapshot: sut.snapshot(), named: "EMPTY_FEED")
    }

    // MARK: - Helpers

    private func makeSUT() -> MVPFeedViewController {
        let bundle = Bundle(for: MVPFeedViewController.self)
        let storyboard = UIStoryboard(name: "MVPFeed", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! MVPFeedViewController
        controller.loadViewIfNeeded()
        return controller
    }

    private func emptyFeed() -> [MVPFeedImageCellController] {
        return []
    }

    private func record(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        guard let snapshotData = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return
        }

        let snapshotURL = URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png")

        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )

            try snapshotData.write(to: snapshotURL)
        } catch {
            XCTFail("Failed to record snapshot with error: \(error)", file: file, line: line)
        }
    }

}

extension UIViewController {
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { action in
            view.layer.render(in: action.cgContext)
        }
    }
}
