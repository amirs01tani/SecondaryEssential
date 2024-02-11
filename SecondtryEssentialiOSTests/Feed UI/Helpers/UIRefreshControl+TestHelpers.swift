//
//  UIRefreshControl+TestHelpers.swift
//  SecondtryEssentialiOSTests
//
//  Created by Amir on 2/11/24.
//

import Foundation
import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}
