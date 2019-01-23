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

enum Validation<Value, Error: InputError> {
    case valid(Value, remark: Error?)
    case invalid(Invalid)

    enum Invalid {
        case empty
        case error(Error)
    }
}

// MARK: - Convenience Getters
extension Validation {

    static func valid(_ value: Value) -> Validation {
        return .valid(value, remark: nil)
    }

    var value: Value? {
        switch self {
        case .valid(let value, _): return value
        default: return nil
        }
    }

    var isValid: Bool {
        return value != nil
    }

    var error: InputError? {
        guard case .invalid(.error(let error)) = self else { return nil }
        return error
    }

	var isError: Bool {
		return error != nil
	}
}
