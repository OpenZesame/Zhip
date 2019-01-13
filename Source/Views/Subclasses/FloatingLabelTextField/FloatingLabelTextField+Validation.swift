//
//  FloatingLabelTextField+Validation.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-13.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import UIKit

extension FloatingLabelTextField {
    
    typealias Color = AnyValidation.Color

    func validate(_ validation: AnyValidation) {
        updateColorsWithValidation(validation)
        updateErrorMessageWithValidation(validation)
    }

    func updateErrorMessageWithValidation(_ validation: AnyValidation) {
        lineErrorColor = Color.error
        errorColor = Color.error
        switch validation {
        case .errorMessage(let errorMessage): self.errorMessage = errorMessage
        case .valid(let remark):
            if let remark = remark {
                self.errorMessage = remark
                lineErrorColor = Color.validWithRemark
                errorColor = Color.validWithRemark
            } else {
                self.errorMessage = nil
            }
        case .empty: errorMessage = nil
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

    func updateColorsWithValidation(_ validation: AnyValidation) {
        updateLineColorWithValidation(validation)
        updatePlaceholderColorWithValidation(validation)
        updateSelectedTitleColorWithValidation(validation)

        let color = colorFromValidation(validation)
        validationCircleView.backgroundColor = color
    }

    func updateLineColorWithValidation(_ validation: AnyValidation) {
        let color: UIColor
        switch validation {
        case .valid(let remark): color = (remark == nil) ? Color.validWithoutRemark : Color.validWithRemark
        default:
            // color of line in case of error is handled by the property `lineErrorColor` in the superclass
            color = Color.empty
        }
        lineColorWhenNoError = color
    }

    func updatePlaceholderColorWithValidation(_ validation: AnyValidation) {
        let color: UIColor
        switch validation {
        case .valid(let remark): color = (remark == nil) ? Color.validWithoutRemark : Color.validWithRemark
        default:
            // color of line in case of error is handled by the property `lineErrorColor` in the superclass
            color = Color.empty
        }
        placeholderColor = color
    }

    func updateSelectedTitleColorWithValidation(_ validation: AnyValidation) {
        let color: UIColor
        switch validation {
        case .valid(let remark): color = (remark == nil) ? Color.validWithoutRemark : Color.validWithRemark
        default:
            // color of line in case of error is handled by the property `lineErrorColor` in the superclass
            color = Color.empty
        }
        selectedTitleColor = color
    }

    func colorFromValidation(_ validation: AnyValidation) -> UIColor {
        let color: UIColor
        switch validation {
        case .empty: color = Color.empty
        case .errorMessage: color = Color.error
        case .valid(let remark): color = (remark == nil) ? Color.validWithoutRemark : Color.validWithRemark
        }
        return color
    }
}
