// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import UIKit

extension Reactive where Base: UIControl {
    var becomeFirstResponder: Binder<Void> {
        Binder(base) { control, _ in _ = control.becomeFirstResponder() }
    }

    var isEnabled: Binder<Bool> {
        Binder(base) { $0.isEnabled = $1 }
    }

    var tap: AnyPublisher<Void, Never> {
        base.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
}

extension Reactive where Base: UILabel {
    var text: Binder<String?> {
        Binder(base) { $0.text = $1 }
    }
}
