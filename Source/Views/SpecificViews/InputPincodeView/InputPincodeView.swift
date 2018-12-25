//
//  InputPincodeView.swift
//  Zupreme
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

    var pincode: ControlProperty<Pincode?> {

        let source: Observable<Pincode?> = Observable.deferred { [weak inputPincodeView = self.base] in
            let pinField = inputPincodeView?.pinField
            return pinField?.pincodeSubject.asObservable().observeOn(MainScheduler.asyncInstance) ?? .empty()
        }

        let bindingObserver = Binder<Pincode?>(base) { $0.pinField.setPincode($1) }

        return ControlProperty(
            values: source,
            valueSink: bindingObserver)
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

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }

    func validate(_ validation: Validation) {
        pinField.validate(validation)

        switch validation {
        case .empty, .valid: errorLabel.text = nil
        case .error(let errorMessage): errorLabel.text = errorMessage
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

        init(length: Int, widthOfDigitView: CGFloat) {
            self.length = length
            self.widthOfDigitView = widthOfDigitView
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
                $0.label.text = nil
            }
            for (index, digit) in digits.enumerated() {
                digitViews[index].label.text = digit.rawValue
            }
        }

        private func setup() {
            withStyle(.horizontalEqualCentering)
            [Void](repeating: (), count: length).map(DigitView.init).forEach {
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

    // swiftlint:disable:next function_body_length
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

enum Digit: String, Codable, Equatable {
    case zero   = "0"
    case one    = "1"
    case two    = "2"
    case three  = "3"
    case four   = "4"
    case five   = "5"
    case six    = "6"
    case seven  = "7"
    case eight  = "8"
    case nine   = "9"
}

private final class DigitView: UIView {

    fileprivate lazy var label = UILabel()

    private lazy var underline: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.height(3)
        view.backgroundColor = Validation.Color.valid
        return view
    }()

    lazy var stackView = UIStackView(arrangedSubviews: [label, underline]).withStyle(UIStackView.Style(spacing: 4, margin: 0))

    init() {
        super.init(frame: .zero)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }

    func colorUnderlineView(with color: UIColor) {
        underline.backgroundColor = color
    }

    private func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.edgesToSuperview()
        label.withStyle(.impression) {
            $0.textAlignment(.center)
        }
    }
}
