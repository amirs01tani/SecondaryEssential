//
//  FeedRefreshViewController.swift
//  SecondtryEssentialiOS
//
//  Created by Amir on 2/11/24.
//

import Foundation
import UIKit

public class MVVMFeedRefreshViewController: NSObject {
    
    private let viewModel: MVVMFeedViewModel
    
    init(viewModel: MVVMFeedViewModel) {
        self.viewModel = viewModel
    }
    
    public lazy var view: UIRefreshControl = {
        return binded(UIRefreshControl())
    }()
    
    @objc func refresh() {
        viewModel.loadFeed()
    }
    
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onLoadingStateChange = { [weak self] viewModel in
            if viewModel.isLoading {
                self?.view.beginRefreshing()
            } else {
                self?.view.endRefreshing()
            }
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
