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

import Foundation
import RxSwift
import RxCocoa

public class ActivityIndicator: SharedSequenceConvertibleType {
    public typealias Element = Bool
    public typealias SharingStrategy = DriverSharingStrategy

    private let lock = NSRecursiveLock()
    private let subject = BehaviorSubject(value: false)
    private lazy var isLoading = subject.asDriverOnErrorReturnEmpty().distinctUntilChanged()

    public init() {}
}

public extension ActivityIndicator {
    func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        return isLoading
    }
}

private extension ActivityIndicator {

    private func subscribed() {
        lock.lock()
        subject.onNext(true)
        lock.unlock()
    }

    private func sendStopLoading() {
        lock.lock()
        subject.onNext(false)
        lock.unlock()
    }

    func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
        return source.asObservable()
            .do(onNext: { _ in
                self.sendStopLoading()
            }, onError: { _ in
                self.sendStopLoading()
            }, onCompleted: {
                self.sendStopLoading()
            }, onSubscribe: subscribed)
    }

}

// MARK: - ObservableConvertibleType + ActivityIndicator
public extension ObservableConvertibleType {
     func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}
