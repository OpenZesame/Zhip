// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import UIKit

extension Reactive where Base: UITextField {
    var placeholder: Binder<String?> {
        Binder(base) { $0.placeholder = $1 }
    }

    /// Write text from ViewModel output.
    var text: Binder<String?> {
        Binder(base) { $0.text = $1 }
    }

    /// Publisher of text changes; use in `inputFromView`.
    var textChanges: AnyPublisher<String?, Never> {
        Publishers.Merge(
            Just(base.text),
            NotificationCenter.default
                .publisher(for: UITextField.textDidChangeNotification, object: base)
                .map { ($0.object as? UITextField)?.text }
        )
        .eraseToAnyPublisher()
    }

    var isEditing: AnyPublisher<Bool, Never> {
        AnyPublisher.merge(
            base.publisher(for: .editingDidBegin).map { true },
            base.publisher(for: .editingDidEnd).map { false }
        )
    }

    var didEndEditing: AnyPublisher<Void, Never> {
        isEditing.filter { !$0 }.mapToVoid()
    }
}

extension Reactive where Base: UITextView {
    /// Write text from ViewModel output.
    var text: Binder<String> {
        Binder(base) { $0.text = $1 }
    }

    var isEditing: AnyPublisher<Bool, Never> {
        AnyPublisher.merge(
            NotificationCenter.default
                .publisher(for: UITextView.textDidBeginEditingNotification, object: base)
                .map { _ in true },
            NotificationCenter.default
                .publisher(for: UITextView.textDidEndEditingNotification, object: base)
                .map { _ in false }
        )
    }

    func isNearBottom(yThreshold: CGFloat = 0.98) -> AnyPublisher<Bool, Never> {
        NotificationCenter.default
            .publisher(for: UITextView.textDidChangeNotification, object: base)
            .map { [weak base] _ -> Bool in
                guard let base else { return false }
                return base.contentOffset.y >= yThreshold * (base.contentSize.height - base.frame.height)
            }
            .eraseToAnyPublisher()
    }

    func didScrollNearBottom(yThreshold: CGFloat = 0.98) -> AnyPublisher<Void, Never> {
        isNearBottom(yThreshold: yThreshold).filter { $0 }.mapToVoid()
    }
}
