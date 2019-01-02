//
//  ConfirmNewPincode.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

private typealias € = L10n.Scene.ConfirmNewPincode

final class ConfirmNewPincode: Scene<ConfirmNewPincodeView> {}

extension ConfirmNewPincode {
    static let title = €.title
}

extension ConfirmNewPincode: RightBarButtonMaking {
    static let makeRight = BarButton.skip
}
