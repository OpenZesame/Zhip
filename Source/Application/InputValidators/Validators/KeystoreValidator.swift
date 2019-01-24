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
import Zesame

struct KeystoreValidator: InputValidator {
    typealias Input = String
    typealias Output = Keystore

    enum Error: InputError {
        case stringToDataConversionFailed
        case badJSON(Swift.DecodingError)
        case incorrectPassword

        init?(walletImportError: Zesame.Error.WalletImport) {
            switch walletImportError {
            case .incorrectPassword: self = .incorrectPassword
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

    func validate(input: Input) -> Validation<Output, Error> {
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
        case .incorrectPassword: return Message.incorrectPassword
        }
    }
}
