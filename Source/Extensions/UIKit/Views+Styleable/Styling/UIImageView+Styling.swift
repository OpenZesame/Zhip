//
//  UIImageView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-19.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

extension UIImageView {
    func setOptional<Attribute>(_ keyPath: ReferenceWritableKeyPath<UIImageView, Attribute?>, ifNotNil attribute: Attribute?) {
        guard let attribute = attribute else { return }
        self[keyPath: keyPath] = attribute
    }

    func set<Attribute>(_ keyPath: ReferenceWritableKeyPath<UIImageView, Attribute>, ifNotNil attribute: Attribute?) {
        guard let attribute = attribute else { return }
        self[keyPath: keyPath] = attribute
    }
}

// MARK: - Style
extension UIImageView {
    struct Style {
        var image: UIImage?
        var contentMode: UIView.ContentMode?
        var clipsToBounds: Bool?

        init(
            image: UIImage? = nil,
            contentMode: UIView.ContentMode? = nil,
            clipsToBounds: Bool? = nil
        ) {
            self.image = image
            self.contentMode = contentMode
            self.clipsToBounds = clipsToBounds
        }
    }
}

// MARK: - Apply Style
extension UIImageView {
    func apply(style: Style) {
        image = style.image
        set(\.contentMode, ifNotNil: style.contentMode)
    }

    @discardableResult
    func withStyle(_ style: UIImageView.Style, customize: ((UIImageView.Style) -> UIImageView.Style)? = nil) -> UIImageView {
        translatesAutoresizingMaskIntoConstraints = false
        let style = customize?(style) ?? style
        apply(style: style)
        return self
    }
}

// MARK: - Style + Customizing
extension UIImageView.Style {

    @discardableResult
    func image(_ image: UIImage?) -> UIImageView.Style {
        var style = self
        style.image = image
        return style
    }

    @discardableResult
    func asset(_ imageAsset: ImageAsset) -> UIImageView.Style {
        return image(imageAsset.image)
    }
}

// MARK: - Style Presets
extension UIImageView.Style {
    static var `default`: UIImageView.Style {
        return UIImageView.Style(
            contentMode: .scaleAspectFit,
            clipsToBounds: true
        )
    }
}
