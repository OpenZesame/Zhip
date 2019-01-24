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
