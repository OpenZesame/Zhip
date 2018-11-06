//
//  Logger.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-06.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

// TODO replace with SwiftyBeaver
struct Logger {
    func error(_ message: CustomStringConvertible) {
        print("🚨 error: \(message.description)")
    }

    func warning(_ message: CustomStringConvertible) {
        print("⚠️ warning: \(message.description)")
    }
}
