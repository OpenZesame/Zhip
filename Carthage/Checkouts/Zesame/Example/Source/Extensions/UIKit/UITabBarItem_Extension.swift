//
//  UITabBarItem_Extension.swift
//  ZesameiOSExample
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

extension UITabBarItem {
    convenience init(_ title: String) {
        self.init(title: title, image: nil, selectedImage: nil)
    }
}
