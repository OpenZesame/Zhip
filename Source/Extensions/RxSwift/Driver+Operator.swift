//
//  Driver+Operator.swift
//  Zhip
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

func --> <E>(driver: Driver<E>, observer: AnyObserver<E>) -> Disposable {
    return driver.drive(observer)
}

func --> (driver: Driver<String>, controlProperty: ControlProperty<String>) -> Disposable {
    return driver.drive(controlProperty)
}

func --> (driver: Driver<String>, controlProperty: ControlProperty<String?>) -> Disposable {
    return driver.drive(controlProperty.orEmpty)
}

func --> (driver: Driver<String>, label: UILabel) -> Disposable {
    return driver --> label.rx.text
}

func --> (driver: Driver<String>, textView: UITextView) -> Disposable {
    return driver --> textView.rx.text.orEmpty.asObserver()
}

func --> (driver: Driver<String?>, textView: UITextView) -> Disposable {
    return driver --> textView.rx.text.asObserver()
}

func --> (driver: Driver<String>, labels: TitledValueView) -> Disposable {
    return driver --> labels.rx.value
}

infix operator <~
func <~ (bag: DisposeBag, disposable: Disposable) {
    disposable.disposed(by: bag)
}
func <~ (bag: DisposeBag, disposables: [Disposable?]) {
    disposables.compactMap { $0 }.forEach {
        $0.disposed(by: bag)
    }
}
