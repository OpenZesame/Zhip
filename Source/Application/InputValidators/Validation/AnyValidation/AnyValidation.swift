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

enum AnyValidation {
    case valid(withRemark: String?)
    case empty
    case errorMessage(String)
    
    init<Value, Error>(_ validation: Validation<Value, Error>) where Error: InputError {
        switch validation {
        case .invalid(let invalid):
            switch invalid {
            case .empty:
                self = .empty
            case .error(let error):
                self = .errorMessage(error.errorMessage)
            }
        case .valid(_, let maybeRemark):
            self = .valid(withRemark: maybeRemark?.errorMessage)
        }
    }
}

// MARK: - Convenience Getters
extension AnyValidation {
    var isValid: Bool {
        switch self {
        case .valid: return true
        default: return false
        }
    }

    var isEmpty: Bool {
        switch self {
        case .empty: return true
        default: return false
        }
    }

    var isError: Bool {
        switch self {
        case .errorMessage: return true
        default: return false
        }
    }
}

// MARK: - ValidationConvertible
extension AnyValidation: ValidationConvertible {
    var validation: AnyValidation { return self }
}
