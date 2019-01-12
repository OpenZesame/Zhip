//
//  UIView+Border.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-10-24.
//  Copyright © 2018 Open Zesame. All rights reserved.
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
