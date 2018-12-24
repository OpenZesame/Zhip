//
//  BackUpRevealedKeyPair.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

final class BackUpRevealedKeyPair: Scene<BackUpRevealedKeyPairView> {}

extension BackUpRevealedKeyPair {
    // keep same title as previous scene
    static let title = L10n.Scene.DecryptKeystoreToRevealKeyPair.title
}

extension BackUpRevealedKeyPair: RightBarButtonMaking, BackButtonHiding {
    static let makeRight: BarButton = .done
}
