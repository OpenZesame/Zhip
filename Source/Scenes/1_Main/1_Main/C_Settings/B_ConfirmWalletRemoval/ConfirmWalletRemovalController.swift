//
//  ConfirmWalletRemovalController.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-12.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

private typealias € = L10n.Scene.ConfirmWalletRemoval

final class ConfirmWalletRemoval: Scene<ConfirmWalletRemovalView> {}

extension ConfirmWalletRemoval {
    static let title = €.title
}

extension ConfirmWalletRemoval: LeftBarButtonMaking {
    static let makeLeft: BarButton = .cancel
}
