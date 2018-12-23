//
//  BackUpRevealedKeyPair.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

private typealias € = L10n.Scene.BackUpRevealedKeyPair

final class BackUpRevealedKeyPair: Scene<BackUpRevealedKeyPairView> {}

extension BackUpRevealedKeyPair {
    static let title = €.title
}

extension BackUpRevealedKeyPair: RightBarButtonMaking, BackButtonHiding {
    static let makeRight: BarButton = .done
}
