//
//  UIControl+Rx.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-18.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UIControl {
    var becomeFirstResponder: Binder<Void> {
        return Binder<Void>(base) { control, _ in
            control.becomeFirstResponder()
        }
    }
}
