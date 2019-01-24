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
import APIKit

public enum Error: Swift.Error {

    indirect case api(API)
    public enum API: Swift.Error {
        /// Error of `URLSession`.
        case connectionError(Swift.Error)

        /// Error while creating `URLRequest` from `Request`.
        case requestError(Swift.Error)

        case timeout

        /// Error while creating `Request.Response` from `(Data, URLResponse)`.
        case responseError(Swift.Error)

        init(from error: APIKit.SessionTaskError) {
            switch error {
            case .connectionError(let inner): self = .connectionError(inner)
            case .requestError(let inner): self = .requestError(inner)
            case .responseError(let inner): self = .responseError(inner)
            }
        }
    }

    case keystorePasswordTooShort(provided: Int, minimum: Int)

    indirect case walletImport(WalletImport)
    public enum WalletImport: Swift.Error {
        case badAddress
        case badPrivateKeyHex
        case jsonStringDecoding
        case jsonDecoding(Swift.DecodingError)
        case incorrectPassword
    }
}
