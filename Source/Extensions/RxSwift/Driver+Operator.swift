// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
