//
//  UITextField+Rx.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-26.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {
    var isValid: Binder<Bool> {
        return Binder<Bool>(base) {
            $0.mark(isValid: $1)
        }
    }
}
