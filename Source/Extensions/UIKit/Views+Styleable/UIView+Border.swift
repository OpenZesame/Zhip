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

extension UIView {
    struct Border {
        let color: CGColor
        let width: CGFloat
        init(color: UIColor, width: CGFloat = 1.5) {
            self.color = color.cgColor
            self.width = width
        }
    }

    func addBorder(_ border: Border) {
        layer.borderWidth = border.width
        layer.borderColor = border.color
    }
}

extension UIView.Border {

    static var empty: UIView.Border {
        return UIView.Border(color: AnyValidation.Color.empty)
    }

    static var error: UIView.Border {
        return UIView.Border(color: AnyValidation.Color.error)
    }

    static func fromValidation(_ validation: AnyValidation) -> UIView.Border {
        switch validation {
        case .empty: return .empty
        case .errorMessage: return .error
        case .valid(let remark):
            let color: UIColor = (remark == nil) ? AnyValidation.Color.validWithoutRemark : AnyValidation.Color.validWithRemark
            return UIView.Border(color: color)
        }
    }
}
