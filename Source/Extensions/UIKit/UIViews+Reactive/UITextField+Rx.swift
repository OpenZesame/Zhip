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
    func updateWith(inputValdation validationResult: InputValidationResult) {

        switch validationResult {
        case .valid: errorMessage = nil
        case .invalid(let invalid):
            switch invalid {
            case .empty: errorMessage = nil
            case .error(let errorMessage): self.errorMessage = errorMessage
            }
        }
    }
}

extension Reactive where Base: TextField {
    var validation: Binder<InputValidationResult> {
        return Binder<InputValidationResult>(base) {
            $0.updateWith(inputValdation: $1)
        }
    }
}
