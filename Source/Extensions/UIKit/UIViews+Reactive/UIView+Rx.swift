//
//  UIView+Rx.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UIView {

    /// Bindable sink for `hidden` property.
    public var isVisible: RxCocoa.Binder<Bool> {
        return Binder(self.base) { view, isVisible in
            view.isHidden = !isVisible
        }
    }
}
