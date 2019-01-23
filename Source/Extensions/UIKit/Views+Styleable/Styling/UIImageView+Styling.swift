//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
        var tintColor: UIColor?
		var backgroundColor: UIColor?
        var contentMode: UIView.ContentMode?
        var clipsToBounds: Bool?

		init(
			image: UIImage? = nil,
			contentMode: UIView.ContentMode? = nil,
			clipsToBounds: Bool? = nil,
			tintColor: UIColor? = nil,
			backgroundColor: UIColor? = nil
			) {
			self.image = image
			self.contentMode = contentMode
			self.clipsToBounds = clipsToBounds
			self.tintColor = tintColor
		}
	}
}

// MARK: - Apply Style
extension UIImageView {
    func apply(style: Style) {
        set(\.image, ifNotNil: style.image)
        set(\.contentMode, ifNotNil: style.contentMode)
        set(\.clipsToBounds, ifNotNil: style.clipsToBounds)
        set(\.tintColor, ifNotNil: style.tintColor)
        set(\.backgroundColor, ifNotNil: style.backgroundColor)
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
    func contentMode(_ contentMode: UIView.ContentMode?) -> UIImageView.Style {
        var style = self
        style.contentMode = contentMode
        return style
    }

    @discardableResult
    func asset(_ imageAsset: ImageAsset) -> UIImageView.Style {
        return image(imageAsset.image)
    }

	@discardableResult
	func backgroundColor(_ backgroundColor: UIColor) -> UIImageView.Style {
		var style = self
		style.backgroundColor = backgroundColor
		return style
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

	static func background(image: UIImage) -> UIImageView.Style {
		return .init(image: image, contentMode: .center, backgroundColor: .clear)
	}
}
