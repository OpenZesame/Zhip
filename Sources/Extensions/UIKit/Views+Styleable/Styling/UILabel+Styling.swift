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

// MARK: - Style
extension UILabel {
    struct Style: Mergeable {
        var text: String?
        var textColor: UIColor?
        var textAlignment: NSTextAlignment?
        var font: UIFont?
        var numberOfLines: Int?
        let backgroundColor: UIColor?
        var adjustsFontSizeMinimumScaleFactor: CGFloat?
        init(
            text: String? = nil,
            textAlignment: NSTextAlignment? = nil,
            textColor: UIColor? = nil,
            font: UIFont? = nil,
            numberOfLines: Int? = nil,
            backgroundColor: UIColor? = nil,
            adjustsFontSizeMinimumScaleFactor: CGFloat? = nil
            ) {
            self.text = text
            self.textColor = textColor
            self.textAlignment = textAlignment
            self.font = font
            self.numberOfLines = numberOfLines
            self.backgroundColor = backgroundColor
            self.adjustsFontSizeMinimumScaleFactor = adjustsFontSizeMinimumScaleFactor
        }
    }
}

// MARK: Apply Style
extension UILabel {
    func apply(style: Style) {
        text = style.text
        font = style.font ?? UIFont.Label.body
        textColor = style.textColor ?? .defaultText
        numberOfLines = style.numberOfLines ?? 1
        textAlignment = style.textAlignment ?? .left
        backgroundColor = style.backgroundColor ?? .clear
        if let minimumScaleFactor = style.adjustsFontSizeMinimumScaleFactor {
            adjustsFontSizeToFitWidth = true
            self.minimumScaleFactor = minimumScaleFactor
        }
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
    func text(_ text: String?) -> UILabel.Style {
        var style = self
        style.text = text
        return style
    }

    @discardableResult
    func font(_ font: UIFont) -> UILabel.Style {
        var style = self
        style.font = font
        return style
    }

    @discardableResult
    func numberOfLines(_ numberOfLines: Int) -> UILabel.Style {
        var style = self
        style.numberOfLines = numberOfLines
        return style
    }

    @discardableResult
    func textAlignment(_ textAlignment: NSTextAlignment) -> UILabel.Style {
        var style = self
        style.textAlignment = textAlignment
        return style
    }

    @discardableResult
    func textColor(_ textColor: UIColor) -> UILabel.Style {
        var style = self
        style.textColor = textColor
        return style
    }

    @discardableResult
    func minimumScaleFactor(_ minimumScaleFactor: CGFloat) -> UILabel.Style {
        var style = self
        style.adjustsFontSizeMinimumScaleFactor = minimumScaleFactor
        return style
    }

}

// MARK: - Style Presets
extension UILabel.Style {

    static var impression: UILabel.Style {
        return UILabel.Style(
            font: UIFont.Label.impression
        )
    }

    static var header: UILabel.Style {
        return UILabel.Style(
            font: UIFont.Label.header,
            numberOfLines: 0
        )
    }

    static var title: UILabel.Style {
        return UILabel.Style(
            font: UIFont.title
        )
    }

    static var body: UILabel.Style {
        return UILabel.Style(
            font: UIFont.Label.body,
            numberOfLines: 0
        )
    }

    static var checkbox: UILabel.Style {
        return UILabel.Style(
            font: UIFont.checkbox,
            numberOfLines: 0
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
            textColor: merge(\.textColor),
            font: merge(\.font),
            numberOfLines: merge(\.numberOfLines),
            backgroundColor: merge(\.backgroundColor)
        )
    }
}
