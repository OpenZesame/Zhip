//
//  UILabel+Styling.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

extension UILabel: Styling, StaticEmptyInitializable, ExpressibleByStringLiteral {

    public static func createEmpty() -> UILabel {
        return UILabel()
    }

    public final class Style: ViewStyle, Makeable, ExpressibleByStringLiteral {

        public typealias View = UILabel

        public let text: String?
        public let textColor: UIColor?
        public let textAlignment: NSTextAlignment?
        public let font: UIFont?
        public let numberOfLines: Int?

        public init(
            _ text: String? = nil,
            height: CGFloat? = nil,
            textAlignment: NSTextAlignment? = nil,
            font: UIFont? = nil,
            textColor: UIColor? = nil,
            numberOfLines: Int? = nil,
            backgroundColor: UIColor? = nil
            ) {
            self.text = text
            self.textColor = textColor
            self.textAlignment = textAlignment
            self.font = font
            self.numberOfLines = numberOfLines
            super.init(height: height, backgroundColor: backgroundColor)
        }

        public convenience init(stringLiteral title: String) {
            self.init(title)
        }

        static var `default`: Style {
            return Style()
        }

        public func merged(other: Style, mode: MergeMode) -> Style {
            func merge<T>(_ attributePath: KeyPath<Style, T?>) -> T? {
                return mergeAttribute(other: other, path: attributePath, mode: mode)
            }

            return Style(
                merge(\.text),
                height: merge(\.height),
                textAlignment: merge(\.textAlignment),
                font: merge(\.font),
                textColor: merge(\.textColor),
                numberOfLines: merge(\.numberOfLines),
                backgroundColor: merge(\.backgroundColor)
            )
        }
    }

    public func apply(style: Style) {
        text = style.text
        font = style.font ?? UIFont.Label.value
        textColor = style.textColor ?? .defaultText
        numberOfLines = style.numberOfLines ?? 1
        textAlignment = style.textAlignment ?? .left
    }
}
public enum MergeMode {
    case overrideOther
    case yieldToOther
}

extension Optional where Wrapped: Makeable {
    func merge(overridingOther other: Wrapped) -> Wrapped {
        return merged(other: other, mode: .overrideOther)
    }

    func merge(yieldingTo other: Wrapped) -> Wrapped {
        return merged(other: other, mode: .yieldToOther)
    }

    private func merged(other: Wrapped, mode: MergeMode) -> Wrapped {
        guard let `self` = self else { return other }
        return `self`.merged(other: other, mode: mode)
    }
}

extension UILabel.Style {
    static var Large: UILabel.Style {
        return UILabel.Style(font: UIFont.Large)
    }
}
