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

extension Reactive where Base: UIButton {
    func title(for state: UIControl.State) -> Binder<String?> {
        Binder(base) { button, title in
            button.setTitle(title, for: state)
        }
    }
}

extension Reactive where Base: UISegmentedControl {
    var value: AnyPublisher<Int, Never> {
        Publishers.Merge(
            Just(base.selectedSegmentIndex),
            base.publisher(for: .valueChanged).map { [weak base] _ in base?.selectedSegmentIndex ?? 0 }
        )
        .eraseToAnyPublisher()
    }
}
