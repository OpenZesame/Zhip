// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit

import RxSwift
import RxCocoa
import TinyConstraints

final class InputPincodeView: UIView {

    lazy var pinField   = PincodeTextField()
    private lazy var errorLabel     = UILabel()
    private lazy var stackView      = UIStackView(arrangedSubviews: [pinField, errorLabel])

    private let hapticFeedbackGenerator = UINotificationFeedbackGenerator()
    private let isClearedOnValidInput: Bool
    init(isClearedOnValidInput: Bool = true) {
        self.isClearedOnValidInput = isClearedOnValidInput
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }

    func validate(_ validation: AnyValidation) {
        pinField.validate(validation)

        switch validation {
        case .valid:
            vibrateOnValid(); fallthrough
        case .empty:
            errorLabel.text = nil
            if isClearedOnValidInput {
                pinField.clearInput()
            }
        case .errorMessage(let errorMessage):
            vibrateOnInvalid()
            errorLabel.text = errorMessage
            shake { [weak self] in
                self?.pinField.clearInput()
            }
        }
    }
}

private extension InputPincodeView {
    func setup() {
        translatesAutoresizingMaskIntoConstraints = true
        stackView.withStyle(.default)
        addSubview(stackView)
        stackView.edgesToSuperview()
        errorLabel.withStyle(.body) {
            $0.textAlignment(.center).textColor(.bloodRed)
        }
    }

    func vibrateOnInvalid() {
        vibrateOnInvalid(hapticFeedbackGenerator: hapticFeedbackGenerator)
    }

    func vibrateOnValid() {
        vibrateOnValid(hapticFeedbackGenerator: hapticFeedbackGenerator)
    }

}

extension UIView {
    
    func vibrateOnInvalid(hapticFeedbackGenerator: UINotificationFeedbackGenerator) {
        vibrate(style: .error, hapticFeedbackGenerator: hapticFeedbackGenerator)
    }
    
    func vibrateOnValid(hapticFeedbackGenerator: UINotificationFeedbackGenerator) {
        vibrate(style: .success, hapticFeedbackGenerator: hapticFeedbackGenerator)
    }
    
    func vibrate(
        style: UINotificationFeedbackGenerator.FeedbackType,
        hapticFeedbackGenerator: UINotificationFeedbackGenerator
    ) {
        hapticFeedbackGenerator.notificationOccurred(style)
    }
}
