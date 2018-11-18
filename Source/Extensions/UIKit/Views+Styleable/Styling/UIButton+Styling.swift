//
//  UIButton+Styling.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

extension UIButton {
    public struct Style {

        let height: CGFloat?
        let textColor: UIColor?
        let colorNormal: UIColor?
        let colorDisabled: UIColor?
        let colorSelected: UIColor?
        let font: UIFont?
        let isEnabled: Bool?
        let borderNormal: Border?

        init(
            height: CGFloat? = nil,
            font: UIFont? = nil,
            textColor: UIColor? = nil,
            colorNormal: UIColor? = nil,
            colorDisabled: UIColor? = nil,
            colorSelected: UIColor? = nil,
            borderNormal: Border? = nil,
            isEnabled: Bool? = nil
            ) {
            self.height = height
            self.textColor = textColor
            self.colorNormal = colorNormal
            self.colorDisabled = colorDisabled
            self.colorSelected = colorSelected
            self.font = font
            self.isEnabled = isEnabled
            self.borderNormal = borderNormal
        }
    }

    func apply(style: Style) {
        translatesAutoresizingMaskIntoConstraints = false
        if let height = style.height {
            self.height(height)
        }
        setTitleColor(style.textColor ?? .defaultText, for: UIControl.State())
        titleLabel?.font = style.font ?? UIFont.Button.primary
        let colorNormal = style.colorNormal ?? .green
        let colorDisabled = style.colorDisabled ?? .gray
        let colorSelected = style.colorSelected ?? colorNormal
        setBackgroundColor(colorNormal, for: .normal)
        setBackgroundColor(colorDisabled, for: .disabled)
        setBackgroundColor(colorSelected, for: .selected)
        isEnabled = style.isEnabled ?? true
        if let borderNormal = style.borderNormal {
            addBorder(borderNormal)
        }
    }
}

private extension CGFloat {
    static let defaultHeight: CGFloat = 64
}

extension UIButton {
    func withStyle(_ style: UIButton.Style) -> UIButton {
        self.apply(style: style)
        return self
    }

    func titled<B>(normal: String) -> B where B: UIButton {
        setTitle(normal, for: .normal)
        guard let button = self as? B else { incorrectImplementation("Bad cast") }
        return button
    }
}

extension UIButton.Style {

    static var hollow: UIButton.Style {
        let color: UIColor = .zilliqaCyan
        return UIButton.Style(
            height: .defaultHeight,
            font: UIFont.Button.primary,
            textColor: color,
            colorNormal: .clear,
            colorDisabled: .black,
            colorSelected: nil,
            borderNormal: UIView.Border(color: color, width: 2),
            isEnabled: true
        )
    }

    static var primary: UIButton.Style {
        return UIButton.Style(
            height: .defaultHeight,
            font: UIFont.Button.primary,
            textColor: .white,
            colorNormal: .zilliqaCyan,
            colorDisabled: .gray,
            colorSelected: nil,
            isEnabled: true
        )
    }

    static var secondary: UIButton.Style {
        return UIButton.Style(
            height: .defaultHeight,
            font: UIFont.Button.seconday,
            textColor: .white,
            colorNormal: .zilliqaDarkBlue,
            colorDisabled: .gray,
            colorSelected: nil,
            isEnabled: true
        )
    }
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: state)
    }

}
