//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
