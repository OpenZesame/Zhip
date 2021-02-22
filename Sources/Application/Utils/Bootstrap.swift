// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation
import IQKeyboardManagerSwift
import SwiftyBeaver
//import Firebase
import Zesame

/// The global logger used throughout the app.
let log = SwiftyBeaver.self

func bootstrap() {
    AppAppearance.setupDefault()
    setupKeyboardHiding()
//    setupCrashReportingIfAllowed()
    setupLogging()
}

//func setupCrashReportingIfAllowed() {
//    guard Preferences.default.isTrue(.hasAcceptedCrashReporting) else {
//        // unsure if this does anything or if it is needed, but seems prudent.
//        FirebaseApp.app()?.delete { _ in
//            /* some required strange ObjC callback that we dont care about `- (void)deleteApp:(FIRAppVoidBoolCallback)completion;` */
//        }
//        return
//    }
//    guard FirebaseApp.app() == nil else {
//        // already configured, will crash if called twice
//        return
//    }
//    FirebaseConfiguration.shared.setLoggerLevel(FirebaseLoggerLevel.min)
//    // Firebase analytics is not enabled, but Crashlytics is setup via Firebase
//    // (the new way of doing it since Google bought Fabric)
//    // So Crashlytics is setup via Firebase.
//    FirebaseApp.configure()
//    Fabric.with([Crashlytics.self])
//}

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
