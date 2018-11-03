//
//  Toast.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-02.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

struct Toast {
    enum Dismissing {
        case after(duration: TimeInterval)
        case manual(dismissButtonTitle: String)
    }

    private let message: String
    private let dismissing: Dismissing
    init(message: String, dismissing: Dismissing = .after(duration: 2)) {
        self.message = message
        self.dismissing = dismissing
    }

    func present(using presenter: Presenter) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        var dismissAction: (() -> Void)?

        switch dismissing {
        case .manual(let dismissTitle):
            let dismissAction = UIAlertAction(title: dismissTitle, style: .default, handler: nil)
            alert.addAction(dismissAction)
        case .after(let duration):
            dismissAction = {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        }

        DispatchQueue.main.async {
            presenter.present(alert, presentation: .present(animated: true))
            dismissAction?()
        }
    }
}

extension Toast: ExpressibleByStringLiteral {
    init(stringLiteral message: String) {
        self.init(message: message)
    }
}
