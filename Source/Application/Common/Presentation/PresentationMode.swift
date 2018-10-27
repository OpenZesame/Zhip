//
//  PresentationMode.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

enum PresentationMode {
    case push(animated: Bool)
    case present(animated: Bool)
}

extension PresentationMode {
    static var animatedPush: PresentationMode {
        return .push(animated: true)
    }
}
