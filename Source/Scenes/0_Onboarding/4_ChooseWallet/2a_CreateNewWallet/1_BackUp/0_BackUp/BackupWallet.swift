//
//  BackupWallet.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-26.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

final class BackupWallet: Scene<BackupWalletView> {}

extension BackupWallet {
    // reuse same title
    static let title = L10n.Scene.CreateNewWallet.title
}

extension BackupWallet: LeftBarButtonMaking {
    static let makeLeft: BarButton = .cancel
}
