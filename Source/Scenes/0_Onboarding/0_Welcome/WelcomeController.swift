//
//  WelcomeController.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-19.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

final class Welcome: Scene<WelcomeView> {}

extension Welcome: NavigationBarLayoutOwner {
    var navigationBarLayout: NavigationBarLayout {
        return .hidden
    }
}
