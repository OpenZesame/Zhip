//
//  BackUpKeystore.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

private typealias € = L10n.Scene.BackUpKeystore

final class BackUpKeystore: Scene<BackUpKeystoreView> {}

extension BackUpKeystore {
    static let title = €.title
}

extension BackUpKeystore: RightBarButtonMaking {
    static let makeRight: BarButton = .done
}
