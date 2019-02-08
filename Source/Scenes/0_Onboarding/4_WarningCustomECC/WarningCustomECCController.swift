//
//  WarningCustomECCController.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-02-08.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import UIKit

final class WarningCustomECC: Scene<WarningCustomECCView> {}

extension WarningCustomECC: NavigationBarLayoutOwner {
    var navigationBarLayout: NavigationBarLayout {
        return .hidden
    }
}
