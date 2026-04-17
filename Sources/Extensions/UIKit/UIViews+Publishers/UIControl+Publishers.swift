// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import UIKit

extension UIControl {
    var becomeFirstResponderBinder: Binder<Void> {
        Binder(self) { control, _ in _ = control.becomeFirstResponder() }
    }

    var isEnabledBinder: Binder<Bool> {
        Binder(self) { $0.isEnabled = $1 }
    }

    var tapPublisher: AnyPublisher<Void, Never> {
        publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
}

extension UILabel {
    var textBinder: Binder<String?> {
        Binder(self) { $0.text = $1 }
    }
}

extension UIButton {
    func titleBinder(for state: UIControl.State) -> Binder<String?> {
        Binder(self) { button, title in
            button.setTitle(title, for: state)
        }
    }
}

extension UISegmentedControl {
    var valuePublisher: AnyPublisher<Int, Never> {
        Publishers.Merge(
            Just(selectedSegmentIndex),
            publisher(for: .valueChanged).map { [weak self] _ in self?.selectedSegmentIndex ?? 0 }
        )
        .eraseToAnyPublisher()
    }
}
