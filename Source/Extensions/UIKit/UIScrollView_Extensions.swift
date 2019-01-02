//
//  UIScrollView_Extensions.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

extension UIScrollView {
    func isContentOffsetNearBottom(precision: CGFloat = 50) -> Bool {
        let yOffset = contentOffset.y
        guard
            yOffset > 0,
            contentSize.height > precision,
            contentSize.height - (yOffset + frame.height) < precision
            else { return false }
        return true
    }
}
