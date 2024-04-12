//
//  UIView+TestHelpers.swift
//  SecondtryEssentialiOSTests
//
//  Created by Amir on 4/12/24.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
