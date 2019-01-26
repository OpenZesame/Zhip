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
