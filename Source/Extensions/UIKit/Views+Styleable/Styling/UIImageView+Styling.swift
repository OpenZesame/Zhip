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
