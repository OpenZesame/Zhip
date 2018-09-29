//
//  ImageHolder.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-31.
//
//

import UIKit

public protocol ImageHolder: class {
    var imageProxy: UIImage? { get set }
}

public protocol ImageViewRepresentable: ImageHolder {
    var isHighlighted: Bool { get set}
    var highlightedImage: UIImage? { get set }
    var animationImages: [UIImage]? { get set }
    var highlightedAnimationImages: [UIImage]? { get set }
    var animationRepeatCount: Int { get set }
    var animationDuration: TimeInterval { get set }
}

extension ImageHolder where Self: UIImageView {
    public var imageProxy: UIImage? {
        get { return image }
        set { image = newValue }
    }
}

extension ImageHolder where Self: UIButton {
    public var imageProxy: UIImage? {
        get { return image(for: .normal) }
        set { setImage(newValue, for: .normal) }
    }
}

extension UIImageView: ImageViewRepresentable {}
extension UIButton: ImageHolder {}

internal extension ImageHolder {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .image(let image):
                self.imageProxy = image
            default: break
            }
        }
    }
}

internal extension ImageViewRepresentable {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .highlightedImage(let image):
                self.highlightedImage = image
            case .animationImages(let images):
                self.animationImages = images
            case .highlightedAnimationImages(let images):
                self.highlightedAnimationImages = images
            case .animationRepeatCount(let count):
                self.animationRepeatCount = count
            case .animationDuration(let duration):
                self.animationDuration = duration
            case .highlighted(let highlighted):
                self.isHighlighted = highlighted
            default:
                break
            }
        }
    }
}
