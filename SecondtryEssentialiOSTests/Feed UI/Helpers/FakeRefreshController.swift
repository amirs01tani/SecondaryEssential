//
//  FakeRefreshController.swift
//  SecondtryEssentialiOSTests
//
//  Created by Amir on 2/11/24.
//

import Foundation
import UIKit

class FakeRefreshControl: UIRefreshControl {
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
