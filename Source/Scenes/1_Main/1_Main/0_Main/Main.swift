//
//  Main.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-16.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

final class Main: Scene<MainView> {}

extension Main: RightBarButtonContentMaking {
    static let makeRightContent = BarButtonContent(title: "⚙️")
}
