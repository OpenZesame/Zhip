//
//  TextField.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import SkyFloatingLabelTextField

import RxCocoa
import RxSwift

private let circeViewSize: CGFloat = 16
private let leftPaddingViewWidth: CGFloat = circeViewSize + 12
private let distanceBetweenCircleAndBottom: CGFloat = 10

final class FloatingLabelTextField: SkyFloatingLabelTextField {

    static let rightViewWidth: CGFloat = 45
    static let textFieldHeight: CGFloat = 64

    private lazy var leftPaddingView      = UIView()
    lazy var validationCircleView = UIView()
    private lazy var textFieldDelegate    = TextFieldDelegate()

    // MARK: - Overridden methods

    // Offset X so that label does not collide with leftView
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.placeholderRect(forBounds: bounds)
        return superRect.insetBy(dx: leftPaddingView.frame.width, dy: 0)
    }

    override func textHeight() -> CGFloat {
        return FloatingLabelTextField.textFieldHeight/2
    }

    override func titleHeight() -> CGFloat {
        return FloatingLabelTextField.textFieldHeight/2
    }

    override var errorMessage: String? {
        didSet { updateFontResizing() }
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return leftPaddingView.frame
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rightViewRect = super.rightViewRect(forBounds: bounds)
        rightViewRect.origin.y = 0
        var size = rightViewRect.size
        size.height = FloatingLabelTextField.textFieldHeight
        size.width = FloatingLabelTextField.rightViewWidth
        rightViewRect.size = size
        return rightViewRect
    }

    /// Allowing for slighly shrinkt font size for error messages that otherwise would not fit.
    /// Shrinking is only performed on the label when showing error messages.
    private func updateFontResizing() {
        titleLabel.adjustsFontSizeToFitWidth = errorMessage != nil
    }
}

// MARK: TextField + Styling
extension FloatingLabelTextField {
    @discardableResult
    func withStyle(_ style: FloatingLabelTextField.Style, customize: ((FloatingLabelTextField.Style) -> FloatingLabelTextField.Style)? = nil) -> FloatingLabelTextField {
        defer { delegate = textFieldDelegate }
        apply(style: customize?(style) ?? style)
        setup()
        return self
    }

    func updateTypeOfInput(_ typeOfInput: TypeOfInput) {
        textFieldDelegate.setTypeOfInput(typeOfInput)
    }
}

// RX
extension Reactive where Base: FloatingLabelTextField {
    var validation: Binder<AnyValidation> {
        return Binder<AnyValidation>(base) {
            $0.validate($1)
        }
    }
}

// MARK: - Private
private extension FloatingLabelTextField {
    func setup() {
        defer {
            // calculations of the position of the circle view might be dependent on other settings, thus do it last
            setupValidationCircleView()
        }
        translatesAutoresizingMaskIntoConstraints = false
        lineErrorColor = AnyValidation.Color.error
        textErrorColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.minimumScaleFactor = 0.8
        updateColorsWithValidation(.empty)

        // prevent capitalization of strings
        titleFormatter = { $0 }
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
        leftPaddingView.frame = CGRect(x: 0, y: 0, width: leftPaddingViewWidth, height: FloatingLabelTextField.textFieldHeight)
    }
}
