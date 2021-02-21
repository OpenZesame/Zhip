// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
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
