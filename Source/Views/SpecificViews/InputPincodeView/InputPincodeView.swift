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

final class InputPincodeView: UITextField {

    private let digitLabelsStackView = UIStackView(frame: .zero).withStyle(.horizontalEqualCentering)

    private let mode: Mode
    private let length = Pincode.length

    private let weakReferencesToDigitView: [Weak<DigitView>]

    private let bag = DisposeBag()
    private let pincodeSubject = PublishSubject<Pincode?>()

    // Use this to read out pincode
    lazy var pincode = pincodeSubject.asDriverOnErrorReturnEmpty()

    // MARK: - Initialization
    init(_ mode: Mode, height: CGFloat = 80) {
        self.mode = mode
        let digitsViews = Array(0..<length).mapToVoid().map(DigitView.init)
        self.weakReferencesToDigitView = digitsViews.map { Weak($0) }
        super.init(frame: .zero)
        setup(height: height)
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }
}

private extension InputPincodeView {

    private var digitViews: [DigitView] {
        guard
            case let digitViews = weakReferencesToDigitView.compactMap({ $0.value }),
            digitViews.count == length
            else { incorrectImplementation("Check weak reference implementation") }
        return digitViews
    }

    // swiftlint:disable:next function_body_length
    func setup(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        self.height(height)
        keyboardType = .numberPad
        isSecureTextEntry = true
        textColor = .clear
        tintColor = .clear
        self.delegate = self

        bag <~ rx.text.asDriver().do(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.setDigits(string: $0)
        }).drive()

        addSubview(digitLabelsStackView)
        digitLabelsStackView.edgesToSuperview()
        digitLabelsStackView.isUserInteractionEnabled = false

        digitViews.forEach {
            digitLabelsStackView.addArrangedSubview($0)
            $0.heightToSuperview()
            $0.width(40)
        }

        // add spacers
        digitLabelsStackView.insertArrangedSubview(.spacer, at: 0)
        digitLabelsStackView.addArrangedSubview(.spacer)
    }

    func setDigits(string: String?) {
        guard let string = string else {
            return setPincode(digits: [])
        }

        guard string.count <= length else {
            return
        }

        guard
            case let digits = string.map(String.init).compactMap(Digit.init),
            digits.count == string.count
            else {
                incorrectImplementation("Did you forget to protect against pasting of strings into the input field?")
        }
        setPincode(digits: digits)
    }

    func setPincode(digits: [Digit]) {
        defer { pincodeSubject.onNext(try? Pincode(digits: digits)) }
        guard digits.count <= length else {
            return
        }
        digitViews.forEach {
            $0.label.text = nil
        }
        for (index, digit) in digits.enumerated() {
            digitViews[index].label.text = digit.rawValue
        }
    }
}

extension InputPincodeView: UITextFieldDelegate {
    // Prevent pasting of non numbers or too long number sequence
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // Always allow erasing of digit
        guard !string.isBackspace else { return true }

        // Dont allow pasting of non numbers
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else { return false }

        let newLength = (textField.text?.count ?? 0) + string.count - range.length

        // Dont allow pasting of strings longer than max length
        return newLength <= length
    }
}

extension String {
    var isBackspace: Bool {
        let char = self.cString(using: String.Encoding.utf8)!
        return strcmp(char, "\\b") == -92
    }
}

extension InputPincodeView {

    enum Mode {
        case setNew
        case match(existing: Pincode)
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

extension InputPincodeView {
    private final class DigitView: UIView {

        fileprivate lazy var label = UILabel()

        private lazy var underline: UIView = {
            let view = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.height(3)
            view.backgroundColor = .black
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

        private func setupSubviews() {
            translatesAutoresizingMaskIntoConstraints = false
            addSubview(stackView)
            stackView.edgesToSuperview()
            label.withStyle(.impression)
        }
    }
}
