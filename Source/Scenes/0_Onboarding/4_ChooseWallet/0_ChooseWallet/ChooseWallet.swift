//
//  ChooseWallet.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

final class ChooseWallet: Scene<ChooseWalletView> {}

extension ChooseWallet: NavigationBarLayoutOwner {
    var navigationBarLayout: NavigationBarLayout {
        return .hidden
    }
}
