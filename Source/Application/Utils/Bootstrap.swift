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
import Firebase

/// The global logger used throughout the app.
let log = SwiftyBeaver.self

func bootstrap() {
    AppAppearance.setupDefault()
    setupKeyboardHiding()
    setupAnalyticsIfAllowed()
    setupLogging()
}

func setupAnalyticsIfAllowed() {
    guard Preferences.default.isTrue(.hasAcceptedAnalyticsTracking) else {
        // unsure if this does anything or if it is needed, but seems prudent.
        FirebaseApp.app()?.delete { _ in
            /* some required strange ObjC callback that we dont care about `- (void)deleteApp:(FIRAppVoidBoolCallback)completion;` */
        }
        return
    }
    guard FirebaseApp.app() == nil else {
        // already configured, will crash if called twice
        return
    }
    FirebaseConfiguration().setLoggerLevel(FirebaseLoggerLevel.min)
    FirebaseApp.configure()
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
