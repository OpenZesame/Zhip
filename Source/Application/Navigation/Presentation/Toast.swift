//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
    private let completion: Completion?

    init(_ message: String, dismissing: Dismissing = .after(duration: 0.6), completion: Completion? = nil) {
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
    func present(using navigationController: UIViewController, dismissedCompletion: Completion? = nil) {
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
            navigationController.present(alert, animated: true, completion: nil)
        }
    }
}
