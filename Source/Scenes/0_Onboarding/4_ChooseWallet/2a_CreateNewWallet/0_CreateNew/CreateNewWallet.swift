//
//  CreateNewWallet.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

private typealias € = L10n.Scene.CreateNewWallet

final class CreateNewWallet: Scene<CreateNewWalletView> {}

extension CreateNewWallet {
    static let title = €.title
}

extension CreateNewWallet: LeftBarButtonMaking {
    static let makeLeft: BarButton = .cancel
}

