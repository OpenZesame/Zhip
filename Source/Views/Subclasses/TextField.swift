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

    private lazy var leftPaddingView      = UIView()
    private lazy var validationCircleView = UIView()
    private lazy var textFieldDelegate    = TextFieldDelegate()

    // MARK: - Overridden methods

    // Offset X so that label does not collide with leftView
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.placeholderRect(forBounds: bounds)
        return superRect.insetBy(dx: leftPaddingView.frame.width, dy: 0)
    }

    override func textHeight() -> CGFloat {
        return textFieldHeight/2
    }

    override func titleHeight() -> CGFloat {
        return textFieldHeight/2
    }

    override var errorMessage: String? {
        didSet { updateFontResizing() }
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return leftPaddingView.frame
    }

    /// Allowing for slighly shrinkt font size for error messages that otherwise would not fit.
    /// Shrinking is only performed on the label when showing error messages.
    private func updateFontResizing() {
        titleLabel.adjustsFontSizeToFitWidth = errorMessage != nil
    }
}

// MARK: TextField + Styling
extension TextField {
    @discardableResult
    func withStyle(_ style: TextField.Style, customize: ((TextField.Style) -> TextField.Style)? = nil) -> TextField {
        defer { delegate = textFieldDelegate }
        apply(style: customize?(style) ?? style)
        setup()
        return self
    }

    func updateTypeOfInput(_ typeOfInput: TypeOfInput) {
        textFieldDelegate.setTypeOfInput(typeOfInput)
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
    typealias Color = Validation.Color
    func setup() {
        defer {
            // calculations of the position of the circle view might be dependent on other settings, thus do it last
            setupValidationCircleView()
        }
        translatesAutoresizingMaskIntoConstraints = false
        lineErrorColor = Color.error
        textErrorColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.minimumScaleFactor = 0.8
        updateColorsWithValidation(.empty)

        // prevent capitalization of strings
        titleFormatter = { $0 }
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
        updatePlaceholderColorWithValidation(validation)
        updateSelectedTitleColorWithValidation(validation)

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

    func updatePlaceholderColorWithValidation(_ validation: Validation) {
        let color: UIColor
        switch validation {
        case .valid: color = Color.valid
        default:
            // color of line in case of error is handled by the property `lineErrorColor` in the superclass
            color = Color.empty
        }
        placeholderColor = color
    }

    func updateSelectedTitleColorWithValidation(_ validation: Validation) {
        let color: UIColor
        switch validation {
        case .valid: color = Color.valid
        default:
            // color of line in case of error is handled by the property `lineErrorColor` in the superclass
            color = Color.empty
        }
        selectedTitleColor = color
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
        validationCircleView.size(CGSize(width: circeViewSize, height: circeViewSize))
        validationCircleView.bottomToSuperview(offset: -distanceBetweenCircleAndBottom)
        validationCircleView.leftToSuperview()
        UIView.Rounding.static(circeViewSize/2).apply(to: validationCircleView)

        leftView = leftPaddingView
        leftViewMode = .always
        leftPaddingView.frame = CGRect(x: 0, y: 0, width: leftPaddingViewWidth, height: textFieldHeight)
    }
}
private let circeViewSize: CGFloat = 16
private let leftPaddingViewWidth: CGFloat = circeViewSize + 12
private let textFieldHeight: CGFloat = 64
private let distanceBetweenCircleAndBottom: CGFloat = 10

final class TextFieldDelegate: NSObject {
    private let maxLength: Int?
    private var allowedCharacters: CharacterSet
    init(allowedCharacters: CharacterSet, maxLength: Int? = nil) {
        self.allowedCharacters = allowedCharacters
        self.maxLength = maxLength
    }
}

extension TextFieldDelegate {
    convenience init(type: TextField.TypeOfInput = .text, maxLength: Int? = nil) {
        self.init(allowedCharacters: type.characterSet, maxLength: maxLength)
    }

    func setTypeOfInput( _ typeOfInput: TextField.TypeOfInput) {
        allowedCharacters = typeOfInput.characterSet
    }
}

extension TextFieldDelegate: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Always allow erasing of digit
        guard !string.isBackspace else { return true }

        // Dont allow pasting of non numbers
        guard allowedCharacters.isSuperset(of: CharacterSet(charactersIn: string)) else { return false }

        guard let maxLength = maxLength else {
            return true
        }
        let newLength = (textField.text?.count ?? 0) + string.count - range.length
        // Dont allow pasting of strings longer than max length
        return newLength <= maxLength
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
