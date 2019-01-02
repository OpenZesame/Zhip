//
//  WarningERC20.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

final class WarningERC20: Scene<WarningERC20View> {}

extension WarningERC20: NavigationBarLayoutOwner {
    var navigationBarLayout: NavigationBarLayout {
        return .hidden
    }
}
