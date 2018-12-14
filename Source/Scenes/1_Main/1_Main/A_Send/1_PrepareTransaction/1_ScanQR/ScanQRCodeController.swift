//
//  ScanQRCodeController.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

private typealias € = L10n.Scene.ScanQRCode

final class ScanQRCode: Scene<ScanQRCodeView> {}

extension ScanQRCode {
    static let title = €.title
}

extension ScanQRCode: LeftBarButtonMaking {
    static let makeLeft: BarButton = .cancel
}
