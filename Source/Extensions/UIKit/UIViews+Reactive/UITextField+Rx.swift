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
}

extension TextField {
    func updateWith(validationErrorMessage: String?) {
        errorMessage = validationErrorMessage
    }
}

extension Reactive where Base: TextField {
    var validation: Binder<String?> {
        return Binder<String?>(base) {
            $0.updateWith(validationErrorMessage: $1)
        }
    }
}
