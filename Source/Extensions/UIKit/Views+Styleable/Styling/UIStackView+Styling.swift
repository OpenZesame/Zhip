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

extension UIEdgeInsets {

    init(top: CGFloat, bottom: CGFloat) {
        self.init(top: top, left: 0, bottom: bottom, right: 0)
    }

    init(all margin: CGFloat) {
        self.init(top: margin, left: margin, bottom: margin, right: margin)
    }

    init(vertical: CGFloat = 0, horizontal: CGFloat = 0) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}

// MARK: - Style
extension UIStackView {
    struct Style {
        static let defaultSpacing: CGFloat = 16
        static let defaultMargin: CGFloat = 16

        var views: [UIView]?
        var axis: NSLayoutConstraint.Axis?
        var alignment: UIStackView.Alignment?
        var distribution: UIStackView.Distribution?
        var spacing: CGFloat?
        var layoutMargins: UIEdgeInsets?
        var isLayoutMarginsRelativeArrangement: Bool?

        init(
            _ views: [UIView]? = nil,
            axis: NSLayoutConstraint.Axis? = nil,
            alignment: UIStackView.Alignment? = nil,
            distribution: UIStackView.Distribution? = nil,
            spacing: CGFloat? = defaultSpacing,
            layoutMargins: UIEdgeInsets? = UIEdgeInsets(all: defaultMargin),
            isLayoutMarginsRelativeArrangement: Bool? = nil
            ) {
            self.views = views
            self.axis = axis
            self.alignment = alignment
            self.distribution = distribution
            self.spacing = spacing
            self.layoutMargins = layoutMargins
            self.isLayoutMarginsRelativeArrangement = isLayoutMarginsRelativeArrangement
        }
    }
}

// MARK: Style + ExpressibleByArrayLiteral
extension UIStackView.Style: ExpressibleByArrayLiteral {
    init(arrayLiteral views: UIView...) {
        self.init(views)
    }
}

extension UIEdgeInsets {
    var isZero: Bool {
        return top == 0 && bottom == 0 && left == 0 && right == 0
    }
}

// MARK: - Apply Style
extension UIStackView {
    func apply(style: Style) {
        if let views = style.views, !views.isEmpty {
            views.reversed().forEach { self.insertArrangedSubview($0, at: 0) }
        }
        axis = style.axis ?? .vertical
        alignment = style.alignment ?? .fill
        distribution = style.distribution ?? .fill
        spacing = style.spacing ?? 0
        if let layoutMargins = style.layoutMargins, !layoutMargins.isZero {
            self.layoutMargins = layoutMargins
            isLayoutMarginsRelativeArrangement = style.isLayoutMarginsRelativeArrangement ?? true
        } else {
            isLayoutMarginsRelativeArrangement = style.isLayoutMarginsRelativeArrangement ?? false
        }
    }

    @discardableResult
    func withStyle(_ style: UIStackView.Style, customize: ((UIStackView.Style) -> UIStackView.Style)? = nil) -> UIStackView {
        translatesAutoresizingMaskIntoConstraints = false
        let style = customize?(style) ?? style
        apply(style: style)
        return self
    }
}

// MARK: - Style + Customizing
extension UIStackView.Style {

    @discardableResult
    func alignment(_ alignment: UIStackView.Alignment) -> UIStackView.Style {
        var style = self
        style.alignment = alignment
        return style
    }

    @discardableResult
    func distribution(_ distribution: UIStackView.Distribution) -> UIStackView.Style {
        var style = self
        style.distribution = distribution
        return style
    }

    @discardableResult
    func spacing(_ spacing: CGFloat) -> UIStackView.Style {
        var style = self
        style.spacing = spacing
        return style
    }

    @discardableResult
    func layoutMargins(_ layoutMargins: UIEdgeInsets) -> UIStackView.Style {
        var style = self
        style.layoutMargins = layoutMargins
        return style
    }
}

// MARK: - Style Presets
extension UIStackView.Style {
    static var `default`: UIStackView.Style {
        return UIStackView.Style([])
    }

    static var vertical: UIStackView.Style {
        return UIStackView.Style(
            layoutMargins: .zero
        )
    }

    static var horizontalEqualCentering: UIStackView.Style {
        return UIStackView.Style(
            axis: .horizontal,
            alignment: .center,
            distribution: .equalCentering,
            spacing: 0,
            layoutMargins: .zero
        )
    }

    static var horizontal: UIStackView.Style {
        return UIStackView.Style(
            axis: .horizontal,
            layoutMargins: .zero
        )
    }

    static var horizontalFillingEqually: UIStackView.Style {
        return UIStackView.Style(
            axis: .horizontal,
            distribution: .fillEqually,
            layoutMargins: .zero)
    }
}
