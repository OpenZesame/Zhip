//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
