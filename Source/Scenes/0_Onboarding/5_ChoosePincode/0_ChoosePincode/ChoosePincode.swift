//
//  ChoosePincode.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

private typealias € = L10n.Scene.ChoosePincode

final class ChoosePincode: Scene<ChoosePincodeView> {}

extension ChoosePincode {
    static let title = €.title
}

extension ChoosePincode: RightBarButtonMaking, BackButtonHiding {
    static let makeRight = BarButton.skip
}
