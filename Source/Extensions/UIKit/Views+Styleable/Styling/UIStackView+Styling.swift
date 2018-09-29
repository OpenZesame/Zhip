//
//  UIStackView+Styling.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

extension UIStackView: Styling, StaticEmptyInitializable {

    public static func createEmpty() -> UIStackView {
        return UIStackView(arrangedSubviews: [])
    }

    public final class Style: ViewStyle, Makeable, ExpressibleByArrayLiteral {

        public typealias View = UIStackView

        let axis: NSLayoutConstraint.Axis?
        let alignment: UIStackView.Alignment?
        let distribution: UIStackView.Distribution?
        let views: [UIView]?
        let spacing: CGFloat?
        let margin: CGFloat?


        public init(
            _ views: [UIView]? = nil,
            axis: NSLayoutConstraint.Axis? = nil,
            alignment: UIStackView.Alignment? = nil,
            distribution: UIStackView.Distribution? = nil,
            spacing: CGFloat? = 16,
            margin: CGFloat? = 16
        ) {
            self.views = views
            self.axis = axis
            self.alignment = alignment
            self.distribution = distribution
            self.spacing = spacing
            self.margin = margin

            // background color is irrelevant for stackviews
            super.init(height: nil, backgroundColor: nil)
        }

        public convenience init(arrayLiteral views: UIView...) {
            self.init(views)
        }

        public static var `default`: Style {
            return Style()
        }

        public func merged(other: Style, mode: MergeMode) -> Style {
            func merge<T>(_ attributePath: KeyPath<Style, T?>) -> T? {
                return mergeAttribute(other: other, path: attributePath, mode: mode)
            }

            return Style(
                merge(\.views),
                axis: merge(\.axis),
                alignment: merge(\.alignment),
                distribution: merge(\.distribution),
                spacing: merge(\.spacing)
            )
        }
    }

    public func apply(style: Style) {
        if let views = style.views, !views.isEmpty {
            views.reversed().forEach { self.insertArrangedSubview($0, at: 0) }
        }
        axis = style.axis ?? .vertical
        alignment = style.alignment ?? .fill
        distribution = style.distribution ?? .fill
        spacing = style.spacing ?? 0
        if let margin = style.margin {
            layoutMargins = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
            isLayoutMarginsRelativeArrangement = true
        }
    }
}
