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

enum AnyValidation {
    case valid(withRemark: String?)
    case empty
    case errorMessage(String)
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
