//
//  FeedRefreshViewController.swift
//  SecondtryEssentialiOS
//
//  Created by Amir on 2/11/24.
//

import Foundation
import UIKit

protocol FeedRefreshViewControllerDelegate {
    func didRequestFeedRefresh()
}

public class MVPFeedRefreshViewController: NSObject, FeedLoadingView {
    
    private let delegate: FeedRefreshViewControllerDelegate
    
    private(set) lazy var view = loadView()
    init(delegate: FeedRefreshViewControllerDelegate) {
            self.delegate = delegate
        }
    
    @objc func refresh() {
        delegate.didRequestFeedRefresh()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
