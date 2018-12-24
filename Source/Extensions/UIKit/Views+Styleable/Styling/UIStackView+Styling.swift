//
//  UIStackView+Styling.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

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
        var margin: CGFloat?
        var isLayoutMarginsRelativeArrangement: Bool?

        init(
            _ views: [UIView]? = nil,
            axis: NSLayoutConstraint.Axis? = nil,
            alignment: UIStackView.Alignment? = nil,
            distribution: UIStackView.Distribution? = nil,
            spacing: CGFloat? = defaultSpacing,
            margin: CGFloat? = defaultMargin,
            isLayoutMarginsRelativeArrangement: Bool? = nil
            ) {
            self.views = views
            self.axis = axis
            self.alignment = alignment
            self.distribution = distribution
            self.spacing = spacing
            self.margin = margin
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
        if let margin = style.margin {
            layoutMargins = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
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
}

// MARK: - Style Presets
extension UIStackView.Style {
    static var `default`: UIStackView.Style {
        return UIStackView.Style()
    }

    static var vertical: UIStackView.Style {
        return UIStackView.Style(
            margin: 0
        )
    }

    static var horizontalEqualCentering: UIStackView.Style {
        return UIStackView.Style(
            axis: .horizontal,
            alignment: .center,
            distribution: .equalCentering,
            spacing: 0,
            margin: 0
        )
    }

    static var horizontal: UIStackView.Style {
        return UIStackView.Style(
            axis: .horizontal,
            margin: 0
        )
    }

    static var horizontalFillingEqually: UIStackView.Style {
        return UIStackView.Style(
            axis: .horizontal,
            distribution: .fillEqually,
            margin: 0)
    }
}
