// MIT License — Copyright (c) 2018-2026 Open Zesame
//
// Provides the `rx` namespace, mirroring RxSwift/RxCocoa convention,
// so that all `someObject.rx.property` call sites remain unchanged.

import Foundation

public struct Reactive<Base> {
    public let base: Base
    public init(_ base: Base) { self.base = base }
}

public protocol ReactiveCompatible: AnyObject {}

public extension ReactiveCompatible {
    var rx: Reactive<Self> { Reactive(self) }
}

extension NSObject: ReactiveCompatible {}
