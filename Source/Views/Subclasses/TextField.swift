//
//  TextField.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import SkyFloatingLabelTextField

final class TextField: SkyFloatingLabelTextField {
    enum TypeOfInput {
        case number, hexadecimal, text
    }
    let typeOfInput: TypeOfInput
    private lazy var leftPaddingView      = UIView()
    private lazy var validationCircleView = UIView()

    init(type: TypeOfInput) {
        self.typeOfInput = type
        super.init(frame: .zero)
        self.delegate = self
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }
}

// MARK: TextField + Styling
extension TextField {
    @discardableResult
    func withStyle<F>(_ style: UITextField.Style, customize: ((UITextField.Style) -> UITextField.Style)? = nil) -> F where F: UITextField {
        setup()
        let style = customize?(style) ?? style
        apply(style: style)
        guard let field = self as? F else { incorrectImplementation("Bad cast") }
        return field
    }
}

extension TextField {
    func validate(_ validation: Validation) {
        updateColorsWithValidation(validation)
        updateErrorMessageWithValidation(validation)
    }
}

import RxCocoa
import RxSwift
extension Reactive where Base: TextField {
    var validation: Binder<Validation> {
        return Binder<Validation>(base) {
            $0.validate($1)
        }
    }
}

private extension TextField {
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        setupValidationCircleView()
        lineErrorColor = Color.error
        updateColorsWithValidation(.empty)
    }

    func updateErrorMessageWithValidation(_ validation: Validation) {
        switch validation {
        case .error(let errorMessage): self.errorMessage = errorMessage
        default: errorMessage = nil
        }
    }

    var lineColorWhenNoError: UIColor {
        set {
            selectedLineColor = newValue
            lineColor = newValue
        }
        get {
            assert(selectedLineColor == lineColor)
            return lineColor
        }
    }

    func updateColorsWithValidation(_ validation: Validation) {
        updateLineColorWithValidation(validation)
        updatePlaceholderAndSelectedTitleColorWithValidation(validation)

        let color = colorFromValidation(validation)
        validationCircleView.backgroundColor = color
    }

    func updateLineColorWithValidation(_ validation: Validation) {
                let color: UIColor
        switch validation {
        case .valid: color = Color.valid
        default:
            // color of line in case of error is handled by the property `lineErrorColor` in the superclass
            color = Color.empty
        }
        lineColorWhenNoError = color
    }

    func updatePlaceholderAndSelectedTitleColorWithValidation(_ validation: Validation) {
        let color: UIColor
        switch validation {
        case .valid: color = Color.valid
        default:
            // color of line in case of error is handled by the property `lineErrorColor` in the superclass
            color = Color.empty
        }
        selectedTitleColor = color
        placeholderColor = color
    }

    enum Color {
        static let valid: UIColor = .teal
        static let error: UIColor = .bloodRed
        static let empty: UIColor = .silverGrey
    }

    func colorFromValidation(_ validation: Validation) -> UIColor {
        let color: UIColor
        switch validation {
        case .empty: color = Color.empty
        case .error: color = Color.error
        case .valid: color = Color.valid
        }
        return color
    }

    func setupValidationCircleView() {
        validationCircleView.translatesAutoresizingMaskIntoConstraints = false
        leftPaddingView.addSubview(validationCircleView)

        let size: CGFloat = 16
        validationCircleView.height(size)
        validationCircleView.width(size)
        validationCircleView.centerYToSuperview()
        validationCircleView.leftToSuperview()
        UIView.Rounding.static(size/2).apply(to: validationCircleView)

        leftView = leftPaddingView
        leftViewMode = .always

        leftPaddingView.frame = CGRect(x: 0, y: 0, width: 16 + 12, height: size)
    }
}

// MARK: UITextFieldDelegate
extension TextField: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Always allow erasing of digit
        guard !string.isBackspace else { return true }

        // Dont allow pasting of non numbers
        guard typeOfInput.characterSet.isSuperset(of: CharacterSet(charactersIn: string)) else { return false }
        return true
    }
}

extension TextField.TypeOfInput {
    var characterSet: CharacterSet {
        switch self {
        case .number: return .decimalDigits
        case .hexadecimal: return .hexadecimalDigits
        case .text: return .alphanumerics
        }
    }
}
