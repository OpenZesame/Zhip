//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
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
        case let .errorMessage(errorMessage): self.errorMessage = errorMessage
        case let .valid(remark):
            if let remark {
                errorMessage = remark
                lineErrorColor = Color.validWithRemark
                errorColor = Color.validWithRemark
            } else {
                errorMessage = nil
            }
        case .empty: errorMessage = nil
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
        let color: UIColor = switch validation {
        case let .valid(remark): (remark == nil) ? Color.validWithoutRemark : Color.validWithRemark
        default:
            // color of line in case of error is handled by the property `lineErrorColor` in the superclass
            Color.empty
        }
        selectedLineColor = color
    }

    func updatePlaceholderColorWithValidation(_ validation: AnyValidation) {
        let color: UIColor = switch validation {
        case let .valid(remark): (remark == nil) ? Color.validWithoutRemark : Color.validWithRemark
        default:
            // color of line in case of error is handled by the property `lineErrorColor` in the superclass
            Color.empty
        }
        placeholderColor = color
    }

    func updateSelectedTitleColorWithValidation(_ validation: AnyValidation) {
        let color: UIColor = switch validation {
        case let .valid(remark): (remark == nil) ? Color.validWithoutRemark : Color.validWithRemark
        default:
            // color of line in case of error is handled by the property `lineErrorColor` in the superclass
            Color.empty
        }
        selectedTitleColor = color
    }

    func colorFromValidation(_ validation: AnyValidation) -> UIColor {
        switch validation {
        case .empty: Color.empty
        case .errorMessage: Color.error
        case let .valid(remark): (remark == nil) ? Color.validWithoutRemark : Color.validWithRemark
        }
    }
}
