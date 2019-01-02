//
//  Bundle+Version+Build.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-02.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

extension Bundle {
    var version: String? {
        return value(of: "CFBundleShortVersionString")
    }

    var build: String? {
        return value(of: "CFBundleVersion")
    }

    func value(of key: String) -> String? {
        guard
            let info = infoDictionary,
            let value = info[key] as? String
            else { return nil }
        return value
    }
}
