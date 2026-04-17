// MIT License — Copyright (c) 2018-2026 Open Zesame

import UIKit

public extension UIView {
    var isVisibleBinder: Binder<Bool> {
        Binder(self) { view, isVisible in
            view.isHidden = !isVisible
        }
    }
}

public extension UIImageView {
    var imageBinder: Binder<UIImage?> {
        Binder(self) { imageView, image in
            imageView.image = image
        }
    }
}
