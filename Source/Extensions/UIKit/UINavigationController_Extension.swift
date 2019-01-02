//
//  UINavigationController_Extension.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-10-27.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

extension UINavigationController {
    convenience init(tabBarTitle: String) {
        self.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(tabBarTitle)
    }
}
