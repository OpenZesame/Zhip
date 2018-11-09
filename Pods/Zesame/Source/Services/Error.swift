//
//  Error.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-09-10.
//  Copyright © 2018 Open Zesame. All rights reserved.
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

    case keystorePasshraseTooShort(provided: Int, minimum: Int)

    indirect case walletImport(WalletImport)
    public enum WalletImport: Swift.Error {
        case badAddress
        case badPrivateKeyHex
        case jsonStringDecoding
        case jsonDecoding(Swift.DecodingError)
        case incorrectPasshrase
    }
}
