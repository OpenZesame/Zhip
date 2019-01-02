//
//  RemovePincode.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

private typealias € = L10n.Scene.RemovePincode

final class RemovePincode: Scene<RemovePincodeView> {}

extension RemovePincode {
    static let title = €.title
}

extension RemovePincode: LeftBarButtonMaking {
    static let makeLeft: BarButton = .cancel
}
