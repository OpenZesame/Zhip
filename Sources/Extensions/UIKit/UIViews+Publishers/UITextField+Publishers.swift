// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import UIKit

extension UITextField {
    var placeholderBinder: Binder<String?> {
        Binder(self) { $0.placeholder = $1 }
    }

    /// Write text from ViewModel output.
    var textBinder: Binder<String?> {
        Binder(self) { $0.text = $1 }
    }

    /// Publisher of text changes; use in `inputFromView`.
    var textPublisher: AnyPublisher<String?, Never> {
        Publishers.Merge(
            Just(text),
            NotificationCenter.default
                .publisher(for: UITextField.textDidChangeNotification, object: self)
                .map { ($0.object as? UITextField)?.text }
        )
        .eraseToAnyPublisher()
    }

    var isEditingPublisher: AnyPublisher<Bool, Never> {
        publisher(for: .editingDidBegin).map { _ in true }
            .merge(with: publisher(for: .editingDidEnd).map { _ in false })
            .eraseToAnyPublisher()
    }

    var didEndEditingPublisher: AnyPublisher<Void, Never> {
        isEditingPublisher.filter { !$0 }.mapToVoid()
    }
}

extension UITextView {
    /// Write text from ViewModel output.
    var textBinder: Binder<String> {
        Binder(self) { $0.text = $1 }
    }

    var didBeginEditingPublisher: AnyPublisher<Void, Never> {
        NotificationCenter.default
            .publisher(for: UITextView.textDidBeginEditingNotification, object: self)
            .mapToVoid()
    }

    var textPublisher: AnyPublisher<String?, Never> {
        Publishers.Merge(
            Just(text),
            NotificationCenter.default
                .publisher(for: UITextView.textDidChangeNotification, object: self)
                .map { ($0.object as? UITextView)?.text }
        )
        .eraseToAnyPublisher()
    }

    var isEditingPublisher: AnyPublisher<Bool, Never> {
        NotificationCenter.default
            .publisher(for: UITextView.textDidBeginEditingNotification, object: self)
            .map { _ in true }
            .merge(
                with: NotificationCenter.default
                    .publisher(for: UITextView.textDidEndEditingNotification, object: self)
                    .map { _ in false }
            )
            .eraseToAnyPublisher()
    }

    func isNearBottomPublisher(yThreshold: CGFloat = 0.98) -> AnyPublisher<Bool, Never> {
        publisher(for: \.contentOffset)
            .map { [weak self] _ -> Bool in
                guard let self else { return false }
                let excess = self.contentSize.height - self.frame.height
                guard excess > 0 else { return true }
                return self.contentOffset.y >= yThreshold * excess
            }
            .eraseToAnyPublisher()
    }

    func didScrollNearBottomPublisher(yThreshold: CGFloat = 0.98) -> AnyPublisher<Void, Never> {
        isNearBottomPublisher(yThreshold: yThreshold).filter { $0 }.mapToVoid()
    }
}
