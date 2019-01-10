//
//  Bundle+Version+Build.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-02.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

extension Bundle {
    enum Key: String {
        case shortVersionString
        case version
        case name

        var key: String {
            return "CFBundle\(rawValue.capitalizingFirstLetter())"
        }
    }

    var version: String? {
        return valueBy(key: .shortVersionString)
    }

    var build: String? {
        return valueBy(key: .version)
    }

    var name: String? {
        return valueBy(key: .name)
    }

    func valueBy(key: Key) -> String? {
        let stringKey = key.key
        return value(of: stringKey)
    }

    func value(of key: String) -> String? {
        guard
            let info = infoDictionary,
            let value = info[key] as? String
            else { return nil }
        return value
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
