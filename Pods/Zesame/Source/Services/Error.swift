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
import APIKit

public enum Error: Swift.Error {

    case api(API)
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

    case walletImport(WalletImport)
    public enum WalletImport: Swift.Error {
        case badAddress
        case badPrivateKeyHex
        case jsonStringDecoding
        case jsonDecoding(Swift.DecodingError)
        case incorrectPassword
        case keystoreError(Swift.Error)
    }

    case keystoreExport(Swift.Error)
    case decryptPrivateKey(Swift.Error)
}
