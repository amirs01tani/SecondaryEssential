//
//  UIRefreshControll+Helpers.swift
//  SecondtryEssentialiOS
//
//  Created by Amir on 3/31/24.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
