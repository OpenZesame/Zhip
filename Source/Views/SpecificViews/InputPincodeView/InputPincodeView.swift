//
//  InputPincodeView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-11.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import TinyConstraints

extension Reactive where Base == InputPincodeView {
    var becomeFirstResponder: Binder<Void> {
        return base.pinField.rx.becomeFirstResponder
    }

    var pincode: Driver<Pincode?> {
        return base.pinField.pincodeDriver
    }

    var validation: Binder<Validation> {
        return Binder<Validation>(base) {
            $0.validate($1)
        }
    }
}

final class InputPincodeView: UIView {

    fileprivate lazy var pinField   = PincodeTextField()
    private lazy var errorLabel     = UILabel()
    private lazy var stackView      = UIStackView(arrangedSubviews: [pinField, errorLabel])

    private let hapticFeedbackGenerator = UINotificationFeedbackGenerator()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }

    func validate(_ validation: Validation) {
        pinField.validate(validation)

        switch validation {
        case .valid: vibrateOnValid(); fallthrough
        case .empty: errorLabel.text = nil
        case .error(let errorMessage):
            vibrateOnInvalid()
            errorLabel.text = errorMessage
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

    func vibrate(style: UINotificationFeedbackGenerator.FeedbackType?) {
        guard let style = style else { return }
        hapticFeedbackGenerator.notificationOccurred(style)
    }

    func vibrateOnInvalid() {
        vibrate(style: .error)
    }

    func vibrateOnValid() {
        vibrate(style: .success)
    }

}

private extension PincodeTextField.Presentation {
    func validate(_ validation: Validation) {
        switch validation {
        case .empty, .valid:
            colorUnderlineViews(with: Validation.Color.valid)
        case .error:
            colorUnderlineViews(with: Validation.Color.error)
        }
    }
}

private final class PincodeTextField: UITextField {
    final class Presentation: UIStackView {

        private var digitViews: [DigitView] {
            let digitViews = arrangedSubviews.compactMap { $0 as? DigitView }
            assert(digitViews.count == length)
            return digitViews
        }

        fileprivate let length: Int
        private let widthOfDigitView: CGFloat
        private let isSecureTextEntry: Bool

        init(length: Int, widthOfDigitView: CGFloat, isSecureTextEntry: Bool = true) {
            self.length = length
            self.widthOfDigitView = widthOfDigitView
            self.isSecureTextEntry = isSecureTextEntry
            super.init(frame: .zero)
            setup()
        }

        required init(coder: NSCoder) { interfaceBuilderSucks }

        func colorUnderlineViews(with color: UIColor) {
            digitViews.forEach {
                $0.colorUnderlineView(with: color)
            }
        }

        func setPincode(_ digits: [Digit]) {
            digitViews.forEach {
                $0.updateWithNumberOrBullet(text: nil)
            }
            for (index, digit) in digits.enumerated() {
                digitViews[index].updateWithNumberOrBullet(text: String(describing: digit))
            }
        }

        private func setup() {
            withStyle(.horizontalEqualCentering)
            [Void](repeating: (), count: length).map { DigitView(isSecureTextEntry: isSecureTextEntry) }.forEach {
                addArrangedSubview($0)
                $0.heightToSuperview()
                $0.width(widthOfDigitView)
            }

            isUserInteractionEnabled = false

            // add spacers left and right, centering the digit views
            insertArrangedSubview(.spacer, at: 0)
            addArrangedSubview(.spacer)
        }
    }

    func validate(_ validation: Validation) {
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
    fileprivate lazy var pincodeDriver = pincodeSubject.asDriverOnErrorReturnEmpty()
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

extension String {
    var isBackspace: Bool {
        let char = self.cString(using: String.Encoding.utf8)!
        return strcmp(char, "\\b") == -92
    }
}

private final class DigitView: UIView {

    private lazy var label = UILabel()

    private lazy var underline: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.height(3)
        view.backgroundColor = Validation.Color.valid
        return view
    }()

    lazy var stackView = UIStackView(arrangedSubviews: [label, underline])

    private let isSecureTextEntry: Bool

    init(isSecureTextEntry: Bool) {
        self.isSecureTextEntry = isSecureTextEntry
        super.init(frame: .zero)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }

    public func updateWithNumberOrBullet(text: String?) {
        guard let text = text else {
            label.text = nil
            return
        }
        let labelText = isSecureTextEntry ? "•" : text
        label.text = labelText
    }

    func colorUnderlineView(with color: UIColor) {
        underline.backgroundColor = color
    }

    private func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.edgesToSuperview()

        stackView.withStyle(.init(spacing: 4, layoutMargins: .zero))

        let font: UIFont = isSecureTextEntry ? .bigBang : .impression
        label.withStyle(.impression) {
            $0.textAlignment(.center)
                .font(font)
        }
    }
}
