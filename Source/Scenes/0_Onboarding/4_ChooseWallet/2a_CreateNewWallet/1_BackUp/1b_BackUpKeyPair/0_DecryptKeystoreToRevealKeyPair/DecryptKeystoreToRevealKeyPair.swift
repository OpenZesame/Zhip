//
//  DecryptKeystoreToRevealKeyPair.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

private typealias € = L10n.Scene.DecryptKeystoreToRevealKeyPair

final class DecryptKeystoreToRevealKeyPair: Scene<DecryptKeystoreToRevealKeyPairView> {}

extension DecryptKeystoreToRevealKeyPair {
    static let title = €.title
}

extension DecryptKeystoreToRevealKeyPair: RightBarButtonMaking {
    static let makeRight: BarButton = .done
}
