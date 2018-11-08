//
//  Presentable.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

protocol Presentable {
    var concrete: UIViewController { get }
}

extension UIViewController: Presentable {
    var concrete: UIViewController { return self }
}
