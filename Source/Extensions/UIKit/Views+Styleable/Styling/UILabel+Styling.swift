//
//  UILabel+Styling.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

// MARK: - Style
extension UILabel {
    struct Style: Mergeable {
        let textColor: UIColor?
        let textAlignment: NSTextAlignment?
        let font: UIFont?
        var numberOfLines: Int?
        let backgroundColor: UIColor?

        init(
            textAlignment: NSTextAlignment? = nil,
            font: UIFont? = nil,
            textColor: UIColor? = nil,
            numberOfLines: Int? = nil,
            backgroundColor: UIColor? = nil
            ) {
            self.textColor = textColor
            self.textAlignment = textAlignment
            self.font = font
            self.numberOfLines = numberOfLines
            self.backgroundColor = backgroundColor
        }
    }
}

// MARK: Apply Style
extension UILabel {
    func apply(style: Style) {
        font = style.font ?? UIFont.Label.value
        textColor = style.textColor ?? .defaultText
        numberOfLines = style.numberOfLines ?? 1
        textAlignment = style.textAlignment ?? .left
        backgroundColor = style.backgroundColor ?? .white
    }

    @discardableResult
    func withStyle(_ style: UILabel.Style, customize: ((UILabel.Style) -> UILabel.Style)? = nil) -> UILabel {
        translatesAutoresizingMaskIntoConstraints = false
        let style = customize?(style) ?? style
        apply(style: style)
        return self
    }
}


// MARK: - Style + Customizing
extension UILabel.Style {
    @discardableResult
    func numberOfLines(_ numberOfLines: Int) -> UILabel.Style {
        var style = self
        style.numberOfLines = numberOfLines
        return style
    }
}

// MARK: - Style Presets
extension UILabel.Style {
    static var title: UILabel.Style {
        return UILabel.Style(
            textAlignment: .center,
            font: UIFont.Label.title,
            numberOfLines: 0
        )
    }

    static var body: UILabel.Style {
        return UILabel.Style(
            font: UIFont.Label.value,
            numberOfLines: 0
        )
    }

    static var checkbox: UILabel.Style {
        return UILabel.Style(
            font: UIFont.Label.value,
            numberOfLines: 0
        )
    }

    static var Large: UILabel.Style {
        return UILabel.Style(font: UIFont.Large)
    }

    static var huge: UILabel.Style {
        return UILabel.Style(
            textAlignment: .center,
            font: UIFont.huge
        )
    }
}

// MARK: - Style + Merging
extension UILabel.Style {
    func merged(other: UILabel.Style, mode: MergeMode) -> UILabel.Style {
        func merge<T>(_ attributePath: KeyPath<UILabel.Style, T?>) -> T? {
            return mergeAttribute(other: other, path: attributePath, mode: mode)
        }

        return UILabel.Style(
            textAlignment: merge(\.textAlignment),
            font: merge(\.font),
            textColor: merge(\.textColor),
            numberOfLines: merge(\.numberOfLines),
            backgroundColor: merge(\.backgroundColor)
        )
    }
}
