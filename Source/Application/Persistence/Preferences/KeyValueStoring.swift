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

/// A typed simple, non thread safe, non async key-value store accessing values using its associatedtype `Key`
protocol KeyValueStoring: AnyKeyValueStoring {
    associatedtype Key: KeyConvertible
    func save<Value>(value: Value, for key: Key)
    func loadValue<Value>(for key: Key) -> Value?
    func deleteValue(for key: Key)
}

// MARK: Default Implementation making use of `AnyKeyValueStoring` protocol
extension KeyValueStoring {

    func save<Value>(value: Value, for key: Key) {
        save(value: value, for: key.key)
    }

    func loadValue<Value>(for key: Key) -> Value? {
        guard let value = loadValue(for: key.key), let typed = value as? Value else { return nil }
        return typed
    }

    func deleteValue(for key: Key) {
        deleteValue(for: key.key)
    }
}

// MARK: - Codable
extension KeyValueStoring {
    func loadCodable<C>(_ modelType: C.Type, for key: Key) -> C? where C: Codable {
        guard
            let json: Data = loadValue(for: key),
            let model = try? JSONDecoder().decode(C.self, from: json)
            else { return nil }
        return model
    }

    func saveCodable<C>(_ model: C, for key: Key) where C: Codable {
        let encoder = JSONEncoder()
        do {
            let json = try encoder.encode(model)
            save(value: json, for: key)
        } catch {
            GlobalTracker.shared.track(error: .failedToSaveCodable(type: C.self))
        }
    }
}

// MARK: Convenience
extension KeyValueStoring {
    func isTrue(_ key: Key) -> Bool {
        guard let bool: Bool = loadValue(for: key) else { return false }
        return bool == true
    }

    func isFalse(_ key: Key) -> Bool {
        return !isTrue(key)
    }
}

final class GlobalTracker: Tracking {
    static let shared = GlobalTracker()
    private let tracker: Tracking = Tracker()
    func track(event: TrackableEvent, context: Any) {
        tracker.track(event: event, context: context)
    }

    func track(error: TrackedError, contextFile: String = #file, contextFunction: String = #function) {
        track(error: error, context: "\(contextFile):\(contextFunction)")
    }

    func track(error: TrackedError, context: String) {
        track(event: error, context: context)
    }
}
