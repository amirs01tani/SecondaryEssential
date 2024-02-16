//
//  UITableView+Dequeueing.swift
//  SecondtryEssentialiOS
//
//  Created by Amir on 2/16/24.
//

import Foundation
import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
