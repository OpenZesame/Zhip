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

final class PincodeTextField: UITextField {

    /// creds: https://stackoverflow.com/a/44701936/1311272
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case #selector(UIResponderStandardEditActions.paste(_:)),
             #selector(UIResponderStandardEditActions.select(_:)),
             #selector(UIResponderStandardEditActions.selectAll(_:)),
             #selector(UIResponderStandardEditActions.copy(_:)),
             #selector(UIResponderStandardEditActions.cut(_:)),
             #selector(UIResponderStandardEditActions.delete(_:)):
            return false
        default:
            return super.canPerformAction(action, withSender: sender)
        }
    }

    /// creds: https://stackoverflow.com/a/10641203/1311272
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        // Prevent long press to show the magnifying glass
        if gestureRecognizer is UILongPressGestureRecognizer {
            gestureRecognizer.isEnabled = false
        }

        super.addGestureRecognizer(gestureRecognizer)
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UILongPressGestureRecognizer && !gestureRecognizer.delaysTouchesEnded {
            return false
        }
        return true
    }

    func validate(_ validation: AnyValidation) {
        presentation.validate(validation)
    }

    private let presentation: Presentation
    private lazy var textFieldDelegate = TextFieldDelegate(type: .number, maxLength: pincodeLength)

    private var pincodeLength: Int {
        return presentation.length
    }

    // only used to listen to change of `text` in the UITextField when it is being edited
    private let bag = DisposeBag()

    fileprivate var pincodeSubject = PublishSubject<Pincode?>()
    lazy var pincodeDriver = pincodeSubject.asDriverOnErrorReturnEmpty()
        // Calling `distinctUntilChanged` really is quite important, since it fixes potential bugs where
        // we use `UIViewController.viewWillAppear` as a trigger for invoking `PincodeTextField.becomeFirstResponder`
        // If we have logic presenting some alert when a pincode was removed, dismissing said alert would cause
        // `viewWillAppear` to be called resulting in `becomeFirstResponder` which would emit the same Pincode,
        // which might result in the same alert being presented.
        .distinctUntilChanged()

    // MARK: - Initialization
    init(height: CGFloat = 80, widthOfDigitView: CGFloat = 40, pincodeLength: Int = Pincode.length) {
        presentation = Presentation(length: pincodeLength, widthOfDigitView: widthOfDigitView)
        super.init(frame: .zero)
        setup(height: height)
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }

    func setPincode(_ pincode: Pincode?) {
        presentation.setPincode(pincode?.digits ?? [])
    }

    func clearInput() {
        setPincode(nil)
        self.text = nil
    }
}

private extension PincodeTextField {

    func setup(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false

        self.height(height)
        keyboardType = .numberPad
        isSecureTextEntry = true
        textColor = .clear
        tintColor = .clear
        self.delegate = textFieldDelegate

        bag <~ rx.text.asDriver().do(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.setDigits(string: $0)
        }).drive()

        addSubview(presentation)
        presentation.edgesToSuperview()
    }

    func setDigits(string: String?) {
        guard let string = string, !string.isEmpty else {
            return setDigits([])
        }

        guard string.count <= pincodeLength else {
            return
        }

        guard
            case let digits = string.map(String.init).compactMap(Digit.init),
            digits.count == string.count
            else {
                incorrectImplementation("Did you forget to protect against pasting of non numerical strings into the input field?")
        }
        setDigits(digits)
    }

    func setDigits(_ digits: [Digit]) {
        defer { pincodeSubject.onNext(try? Pincode(digits: digits)) }
        guard digits.count <= pincodeLength else {
            return
        }
        presentation.setPincode(digits)
    }
}

private extension PincodeTextField.Presentation {
    func validate(_ validation: AnyValidation) {
        switch validation {
        case .empty, .valid:
            colorUnderlineViews(with: AnyValidation.Color.validWithoutRemark)
        case .errorMessage:
            colorUnderlineViews(with: AnyValidation.Color.error)
        }
    }
}

extension String {
    var isBackspace: Bool {
        let char = self.cString(using: String.Encoding.utf8)!
        return strcmp(char, "\\b") == -92
    }
}
