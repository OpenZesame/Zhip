//
//  Version.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import Foundation

struct Version {
    let version: String
    let build: String
}

extension Version {
    static func fromBundle() -> Self {
        let bundle = Bundle.main
        
        let version: String = bundle.value(for: "CFBundleShortVersionString") ?? "1.0"
        let build: String = bundle.value(for: "CFBundleVersion") ?? "1"
        
        return Version(version: version, build: build)
    }
}

extension Bundle {
    func value<Value>(for key: String) -> Value? {
        object(forInfoDictionaryKey: key) as? Value
    }
}
