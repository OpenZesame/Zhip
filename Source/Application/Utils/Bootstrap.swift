//
//  Bootstrap.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-06.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift
import SwiftyBeaver

let log = SwiftyBeaver.self

func bootstrap() {
    IQKeyboardManager.shared.enable = true

    let console = ConsoleDestination()
    log.addDestination(console)
}
