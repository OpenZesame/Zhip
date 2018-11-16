//
//  PresentationMode.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

typealias PresentationCompletion = () -> Void

enum PresentationMode {
    case push(animated: Bool)
    case present(animated: Bool, completion: PresentationCompletion?)
}

extension PresentationMode {

    static var `default`: PresentationMode { return .animatedPush }

    static var animatedPush: PresentationMode {
        return .push(animated: true)
    }

    static var animatedPresent: PresentationMode {
        return .present(animated: true, completion: nil)
    }
}
