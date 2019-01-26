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
extension UITextView {
    struct Style {
        var text: String?
        var textAlignment: NSTextAlignment?
        var textColor: UIColor?
        var backgroundColor: UIColor?
        var font: UIFont?
        var isEditable: Bool?
        var isSelectable: Bool?
        var contentInset: UIEdgeInsets?
        var isScrollEnabled: Bool?

        init(
            text: String? = nil,
            textAlignment: NSTextAlignment? = nil,
            height: CGFloat? = nil,
            font: UIFont? = nil,
            textColor: UIColor? = nil,
            backgroundColor: UIColor? = nil,
            isEditable: Bool? = nil,
            isSelectable: Bool? = nil,
            isScrollEnabled: Bool? = nil,
            contentInset: UIEdgeInsets? = nil
            ) {
            self.text = text
            self.textAlignment = textAlignment
            self.textColor = textColor
            self.font = font
            self.isEditable = isEditable
            self.isSelectable = isSelectable
            self.isScrollEnabled = isScrollEnabled
            self.contentInset = contentInset
            self.backgroundColor = backgroundColor
        }
    }
}

// MARK: Apply Style
extension UITextView {
    func apply(style: UITextView.Style) {
        text = style.text
        textAlignment = style.textAlignment ?? .left
        font = style.font ?? UIFont.body
        textColor = style.textColor ?? .defaultText
        backgroundColor = style.backgroundColor ?? .clear
        isEditable = style.isEditable ?? true
        isSelectable = style.isSelectable ?? true
        isScrollEnabled = style.isScrollEnabled ?? true
        contentInset = style.contentInset ?? UIEdgeInsets.zero
    }

    @discardableResult
    func withStyle(_ style: UITextView.Style, customize: ((UITextView.Style) -> UITextView.Style)? = nil) -> UITextView {
        translatesAutoresizingMaskIntoConstraints = false
        let style = customize?(style) ?? style
        apply(style: style)
        return self
    }
}

// MARK: - Style + Customizing
extension UITextView.Style {

    @discardableResult
    func text(_ text: String?) -> UITextView.Style {
        var style = self
        style.text = text
        return style
    }

    @discardableResult
    func font(_ font: UIFont) -> UITextView.Style {
        var style = self
        style.font = font
        return style
    }

    @discardableResult
    func textAlignment(_ textAlignment: NSTextAlignment) -> UITextView.Style {
        var style = self
        style.textAlignment = textAlignment
        return style
    }

    @discardableResult
    func textColor(_ textColor: UIColor) -> UITextView.Style {
        var style = self
        style.textColor = textColor
        return style
    }
}

// MARK: - Style Presets
extension UITextView.Style {
    static var nonEditable: UITextView.Style {
        return UITextView.Style(
            isEditable: false
        )
    }

    static var nonSelectable: UITextView.Style {
        return UITextView.Style(
            textAlignment: .center,
            isEditable: false,
            isSelectable: false
        )
    }

    static var editable: UITextView.Style {
        return UITextView.Style(
            isEditable: true
        )
    }

    static var header: UITextView.Style {
        return UITextView.Style(
            textAlignment: .center,
            font: UIFont.header,
            isEditable: false
        )
    }

//    static var impression: UITextView.Style {
//        return UITextView.Style(
//            font: UIFont.impression,
//            isEditable: false
//        )
//    }
}

// MARK: - Style + Merging
extension UITextView.Style: Mergeable {
    func merged(other: UITextView.Style, mode: MergeMode) -> UITextView.Style {
        func merge<T>(_ attributePath: KeyPath<UITextView.Style, T?>) -> T? {
            return mergeAttribute(other: other, path: attributePath, mode: mode)
        }

        return UITextView.Style(
            textAlignment: merge(\.textAlignment),
            font: merge(\.font),
            textColor: merge(\.textColor),
            backgroundColor: merge(\.backgroundColor),
            isEditable: merge(\.isEditable),
            isSelectable: merge(\.isSelectable),
            isScrollEnabled: merge(\.isScrollEnabled),
            contentInset: merge(\.contentInset)
        )
    }
}

