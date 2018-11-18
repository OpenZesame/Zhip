//
//  PrepareTransaction.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

private typealias € = L10n.Scene.PrepareTransaction

final class PrepareTransaction: Scene<PrepareTransactionView> {}

extension PrepareTransaction {
    static let title = €.title
}

extension PrepareTransaction: RightBarButtonMaking {
    static let makeRight: BarButton = .cancel
}
