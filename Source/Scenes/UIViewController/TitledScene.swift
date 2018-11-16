//
//  TitledScene.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

protocol TitledScene {
    static var title: String { get }
}

extension TitledScene {
    static var title: String { return "" }
    var sceneTitle: String { return Self.title }
}
