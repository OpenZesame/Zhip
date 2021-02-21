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
import KeychainSwift

extension KeychainSwift: KeyValueStoring {
    typealias Key = KeychainKey

    func loadValue(for key: String) -> Any? {
        if let data = getData(key) {
            return data
        } else if let bool = getBool(key) {
            return bool
        } else if let string = get(key) {
            return string
        } else {
            return nil
        }
    }

    /// Saves items in Keychain using access option `kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly`
    /// Do not that means that if the user unsets the iOS passcode for their iOS device, then all data
    /// will be lost, read more:
    /// https://developer.apple.com/documentation/security/ksecattraccessiblewhenpasscodesetthisdeviceonly
    func save(value: Any, for key: String) {
        let access: KeychainSwiftAccessOptions = .accessibleWhenPasscodeSetThisDeviceOnly
        if let data = value as? Data {
            set(data, forKey: key, withAccess: access)
        } else if let bool = value as? Bool {
            set(bool, forKey: key, withAccess: access)
        } else if let string = value as? String {
            set(string, forKey: key, withAccess: access)
        }
    }

    func deleteValue(for key: String) {
        delete(key)
    }
}
