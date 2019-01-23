//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
