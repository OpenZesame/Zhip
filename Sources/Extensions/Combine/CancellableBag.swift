// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import Foundation

public final class CancellableBag {
    public var cancellables = Set<AnyCancellable>()
    public init() {}
    deinit { cancellables.forEach { $0.cancel() } }
}

public typealias DisposeBag = CancellableBag
public typealias Disposable = AnyCancellable

public extension AnyCancellable {
    func disposed(by bag: CancellableBag) {
        store(in: &bag.cancellables)
    }
}
