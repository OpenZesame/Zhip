//
//  ActivityIndicator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
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
