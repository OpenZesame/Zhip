//
//  KeystoreValidator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import Zesame

struct KeystoreValidator: InputValidator {
    typealias Input = String
    typealias Output = Keystore

    enum Error: InputError {
        case stringToDataConversionFailed
        case badJSON(Swift.DecodingError)
        case incorrectPassphrase

        init?(walletImportError: Zesame.Error.WalletImport) {
            switch walletImportError {
            case .incorrectPasshrase: self = .incorrectPassphrase
            default: return nil
            }
        }

        init?(error: Swift.Error) {
            guard
                let zesameError = error as? Zesame.Error,
                case .walletImport(let walletImportError) = zesameError
                else { return nil }
            self.init(walletImportError: walletImportError)
        }
    }

    func validate(input: Input) -> InputValidationResult<Output, Error> {
        func validate() throws -> Keystore {
            guard let json = input.data(using: .utf8) else {
                throw Error.stringToDataConversionFailed
            }

            do {
                return try JSONDecoder().decode(Keystore.self, from: json)
            } catch let jsonDecoderError as Swift.DecodingError {
                throw Error.badJSON(jsonDecoderError)
            } catch {
                incorrectImplementation("DecodingError should cover all errors")
            }
        }

        do {
            return .valid(try validate())
        } catch let error as Error {
            return .invalid(.error(error))
        } catch {
            incorrectImplementation("All errors should have been covered")
        }
    }
}

extension KeystoreValidator.Error {
    var errorMessage: String {
        let Message = L10n.Error.Input.Keystore.self

        switch self {
        case .badJSON, .stringToDataConversionFailed: return Message.badFormatOrInput
        case .incorrectPassphrase: return Message.incorrectPassphrase
        }
    }
}
