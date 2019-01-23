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

import Foundation
import RxSwift
import RxCocoa

public class ActivityIndicator: SharedSequenceConvertibleType {
    // swiftlint:disable:next type_name
    public typealias E = Bool
    public typealias SharingStrategy = DriverSharingStrategy

    private let lock = NSRecursiveLock()
    private let subject = BehaviorSubject(value: false)
    private lazy var isLoading = subject.asDriverOnErrorReturnEmpty().distinctUntilChanged()

    public init() {}
}

public extension ActivityIndicator {
    func asSharedSequence() -> SharedSequence<SharingStrategy, E> {
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

    func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.E> {
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
     func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<E> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}
