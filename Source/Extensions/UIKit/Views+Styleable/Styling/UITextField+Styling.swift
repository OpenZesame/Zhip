//
//  UITextField+Styling.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import TinyConstraints

extension UITextField: EmptyInitializable, Styling, StaticEmptyInitializable, ExpressibleByStringLiteral {

    public static func createEmpty() -> UITextField {
        return UITextField(frame: .zero)
    }

    public final class Style: ViewStyle, Makeable, ExpressibleByStringLiteral {

        public typealias View = UITextField

        public let placeholder: String?
        public let text: String?
        public let textColor: UIColor?
        public let font: UIFont?
        public let isSecureTextEntry: Bool?

        public init(
            _ placeholder: String? = nil,
            text: String? = nil,
            height: CGFloat? = nil,
            font: UIFont? = nil,
            textColor: UIColor? = nil,
            backgroundColor: UIColor? = nil,
            isSecureTextEntry: Bool? = nil
            ) {
            self.placeholder = placeholder
            self.text = text
            self.font = font
            self.textColor = textColor
            self.isSecureTextEntry = isSecureTextEntry
            super.init(height: height ?? .defaultHeight, backgroundColor: backgroundColor)
        }

        public convenience init(stringLiteral placeholder: String) {
            self.init(placeholder)
        }

        public func merged(other: Style, mode: MergeMode) -> Style {
            func merge<T>(_ attributePath: KeyPath<Style, T?>) -> T? {
                return mergeAttribute(other: other, path: attributePath, mode: mode)
            }

            return Style(
                merge(\.placeholder),
                text: merge(\.text),
                height: merge(\.height),
                font: merge(\.font),
                textColor: merge(\.textColor),
                backgroundColor: merge(\.backgroundColor),
                isSecureTextEntry: merge(\.isSecureTextEntry)
            )
        }
    }

    public func apply(style: Style) {
        placeholder = style.placeholder
        textColor = style.textColor ?? .defaultText
        font = style.font ?? .default
        text = style.text
        isSecureTextEntry = style.isSecureTextEntry ?? false
        addBorder()
    }
}

public extension CGFloat {
    static var defaultHeight: CGFloat { return 44 }
}
