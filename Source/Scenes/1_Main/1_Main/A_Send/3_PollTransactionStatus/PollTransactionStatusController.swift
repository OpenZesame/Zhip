//
//  PollTransactionStatusController.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

private typealias € = L10n.Scene.PollTransactionStatus

final class PollTransactionStatus: Scene<PollTransactionStatusView> {}

extension PollTransactionStatus: BackButtonHiding {}

extension PollTransactionStatus: NavigationBarLayoutOwner {
    var navigationBarLayout: NavigationBarLayout {
        return .transluscent
    }
}
