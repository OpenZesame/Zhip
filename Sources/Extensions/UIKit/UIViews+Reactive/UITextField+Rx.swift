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
        base.publisher(for: .editingDidBegin).map { _ in true }
            .merge(with: base.publisher(for: .editingDidEnd).map { _ in false })
            .eraseToAnyPublisher()
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

    var didBeginEditing: AnyPublisher<Void, Never> {
        NotificationCenter.default
            .publisher(for: UITextView.textDidBeginEditingNotification, object: base)
            .mapToVoid()
    }

    var textChanges: AnyPublisher<String?, Never> {
        Publishers.Merge(
            Just(base.text),
            NotificationCenter.default
                .publisher(for: UITextView.textDidChangeNotification, object: base)
                .map { ($0.object as? UITextView)?.text }
        )
        .eraseToAnyPublisher()
    }

    var isEditing: AnyPublisher<Bool, Never> {
        NotificationCenter.default
            .publisher(for: UITextView.textDidBeginEditingNotification, object: base)
            .map { _ in true }
            .merge(
                with: NotificationCenter.default
                    .publisher(for: UITextView.textDidEndEditingNotification, object: base)
                    .map { _ in false }
            )
            .eraseToAnyPublisher()
    }

    func isNearBottom(yThreshold: CGFloat = 0.98) -> AnyPublisher<Bool, Never> {
        base.publisher(for: \.contentOffset)
            .map { [weak base] _ -> Bool in
                guard let base else { return false }
                let excess = base.contentSize.height - base.frame.height
                guard excess > 0 else { return true }
                return base.contentOffset.y >= yThreshold * excess
            }
            .eraseToAnyPublisher()
    }

    func didScrollNearBottom(yThreshold: CGFloat = 0.98) -> AnyPublisher<Void, Never> {
        isNearBottom(yThreshold: yThreshold).filter { $0 }.mapToVoid()
    }
}
