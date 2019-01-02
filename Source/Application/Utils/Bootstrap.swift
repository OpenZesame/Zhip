//
//  Bootstrap.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-06.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift
import SwiftyBeaver

/// The global logger used throughout the app.
let log = SwiftyBeaver.self

func bootstrap() {
    AppAppearance.setupDefault()
    setupKeyboardHiding()

    setupLogging()
}

private func setupKeyboardHiding() {
    IQKeyboardManager.shared.enable = true
}

private func setupLogging() {
     // only allow logging for Debug builds
    guard isDebug else { return }
    let console = ConsoleDestination()
    console.minLevel = .verbose
    log.addDestination(console)
}
