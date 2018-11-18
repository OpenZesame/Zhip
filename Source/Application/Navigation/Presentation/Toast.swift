//
//  Toast.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-02.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

/// Small message to be displayed to user, named after Android equivalence.
struct Toast {
    enum Dismissing {
        case after(duration: TimeInterval)
        case manual(dismissButtonTitle: String)
    }

    private let message: String
    private let dismissing: Dismissing
    private let completion: PresentationCompletion?

    init(_ message: String, dismissing: Dismissing = .after(duration: 1.2), completion: PresentationCompletion? = nil) {
        self.message = message
        self.dismissing = dismissing
        self.completion = completion
    }

}

// MARK: ExpressibleByStringLiteral
extension Toast: ExpressibleByStringLiteral {
    init(stringLiteral message: String) {
        self.init(message)
    }
}

// MARK: - Toast + Presentation
extension Toast {
    func present(using presenter: UIViewController, dismissedCompletion: PresentationCompletion? = nil) {
        let dismissedCompletion = dismissedCompletion ?? self.completion
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        switch dismissing {
        case .manual(let dismissTitle):
            let dismissAction = UIAlertAction(title: dismissTitle, style: .default) { _ in
                dismissedCompletion?()
            }
            alert.addAction(dismissAction)
        case .after(let duration):
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                alert.dismiss(animated: true, completion: dismissedCompletion)
            }
        }

        DispatchQueue.main.async {
            presenter.present(alert, animated: true, completion: nil)
        }
    }
}
