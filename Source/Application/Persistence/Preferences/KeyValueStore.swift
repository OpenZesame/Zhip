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
