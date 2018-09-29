//
//  Driver+Operator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-10.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

infix operator -->
func --> <E>(driver: Driver<E>, binder: Binder<E>) -> Disposable {
    return driver.drive(binder)
}
func --> <E>(driver: Driver<E>, binder: Binder<E?>) -> Disposable {
    return driver.drive(binder)
}
func --> (driver: Driver<String>, label: UILabel) -> Disposable {
    return driver --> label.rx.text
}
func --> (driver: Driver<String>, labels: LabelsView) -> Disposable {
    return driver --> labels.rx.value
}
