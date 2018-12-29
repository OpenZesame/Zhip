//
//  UIView+Border.swift
//  Zupreme
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
        return UIView.Border(color: Validation.Color.empty)
    }

    static var error: UIView.Border {
        return UIView.Border(color: Validation.Color.error)
    }

    static var valid: UIView.Border {
        return UIView.Border(color: Validation.Color.valid)
    }

    static func fromValidation(_ validation: Validation) -> UIView.Border {
        switch validation {
        case .empty: return .empty
        case .error: return .error
        case .valid: return .valid
        }
    }
}
