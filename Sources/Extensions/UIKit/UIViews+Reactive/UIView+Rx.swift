// MIT License — Copyright (c) 2018-2026 Open Zesame

import UIKit

public extension Reactive where Base: UIView {
    var isVisible: Binder<Bool> {
        Binder(base) { view, isVisible in
            view.isHidden = !isVisible
        }
    }
}
