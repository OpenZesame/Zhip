// MIT License — Copyright (c) 2018-2026 Open Zesame

import Foundation

/// Write-only wrapper that always applies values on the main thread.
public struct Binder<Value> {
    private let _binding: (Value) -> Void

    public init<Object: AnyObject>(
        _ object: Object,
        binding: @escaping (Object, Value) -> Void
    ) {
        _binding = { [weak object] value in
            guard let object else { return }
            if Thread.isMainThread {
                binding(object, value)
            } else {
                DispatchQueue.main.async { binding(object, value) }
            }
        }
    }

    public func on(_ value: Value) {
        _binding(value)
    }
}
