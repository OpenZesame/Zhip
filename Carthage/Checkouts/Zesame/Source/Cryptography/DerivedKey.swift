//
//  DerivedKey.swift
//  Zesame-iOS
//
//  Created by Alexander Cyon on 2018-09-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import EllipticCurveKit

public struct DerivedKey {
    public let data: Data
    public let parametersUsed: Scrypt.Parameters
    fileprivate init(data: DataConvertible, parametersUsed: Scrypt.Parameters) {
        self.data = data.asData
        self.parametersUsed = parametersUsed
    }
}

extension DerivedKey: DataConvertible {}
public extension DerivedKey {
    var asData: Data {
        return data
    }
}

public extension Scrypt {
    public func deriveKey(passphrase: String, done: @escaping (DerivedKey) -> Void) {
        background {
            let data = try! self.calculate(password: passphrase)
            let derivedKey = DerivedKey(data: data, parametersUsed: self.params)
            main {
                done(derivedKey)
            }
        }
    }
}
