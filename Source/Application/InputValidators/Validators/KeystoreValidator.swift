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
