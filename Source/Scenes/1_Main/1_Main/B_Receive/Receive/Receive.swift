//
//  Receive.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

private typealias € = L10n.Scene.Receive

final class Receive: Scene<ReceiveView> {}

extension Receive: BackButtonHiding {
    static let title = €.title
}

extension Receive: RightBarButtonMaking {
    static let makeRight: BarButton = .done
}
