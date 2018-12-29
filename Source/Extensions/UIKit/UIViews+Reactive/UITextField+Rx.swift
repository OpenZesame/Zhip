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

    var placeholder: Binder<String?> {
        return Binder(base) {
            $0.placeholder = $1
        }
    }

    var isEditing: Driver<Bool> {
        return Driver.merge(
            controlEvent([.editingDidBegin]).asDriver().map { true },
            controlEvent([.editingDidEnd]).asDriver().map { false }
        )
    }

//    var didEndEditing: Driver<Void> {
//        return isEditing.filter { !$0 }.mapToVoid()
//    }
}

extension Reactive where Base: UITextView {
    var isEditing: Driver<Bool> {
        return Driver.merge(
            didBeginEditing.asDriver().map { true },
            didEndEditing.asDriver().map { false }
        )
    }
}
