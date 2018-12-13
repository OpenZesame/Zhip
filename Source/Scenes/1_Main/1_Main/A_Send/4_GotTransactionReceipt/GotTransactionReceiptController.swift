//
//  GotTransactionReceiptController.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

private typealias € = L10n.Scene.GotTransactionReceipt

final class GotTransactionReceipt: Scene<GotTransactionReceiptView> {}

extension GotTransactionReceipt: BackButtonHiding {
    static let title = €.title
}

extension GotTransactionReceipt: RightBarButtonMaking {
    static let makeRight: BarButton = .done
}
