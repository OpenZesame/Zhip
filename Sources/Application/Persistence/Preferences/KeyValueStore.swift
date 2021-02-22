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

/// A type-erasing key-value store that wraps some type confirming to `KeyValueStoring`
struct KeyValueStore<KeyType>: KeyValueStoring where KeyType: KeyConvertible {
    typealias Key = KeyType

    private let _save: (Any, String) -> Void
    private let _load: (String) -> Any?
    private let _delete: (String) -> Void

    init<Concrete>(_ concrete: Concrete) where Concrete: KeyValueStoring, Concrete.Key == KeyType {
        _save = { concrete.save(value: $0, for: $1) }
        _load = { concrete.loadValue(for: $0) }
        _delete = { concrete.deleteValue(for: $0) }
    }
}

// MARK: - KeyValueStoring Methods
extension KeyValueStore {
    func save(value: Any, for key: String) {
        _save(value, key)
    }

    func loadValue(for key: String) -> Any? {
        return _load(key)
    }

    func deleteValue(for key: String) {
        _delete(key)
    }
}
