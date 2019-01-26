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
