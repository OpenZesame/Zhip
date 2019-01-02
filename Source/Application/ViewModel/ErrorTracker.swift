//
//  ErrorTracker.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-24.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

// Stolen from: https://github.com/sergdort/CleanArchitectureRxSwift
public final class ErrorTracker: SharedSequenceConvertibleType {
    public typealias SharingStrategy = DriverSharingStrategy
    private let _subject = PublishSubject<Error>()

    public func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.E> {
        return source.asObservable().do(onError: onError)
    }

    public func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        return _subject.asObservable().asDriverOnErrorReturnEmpty()
    }

    public func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }

    private func onError(_ error: Error) {
        _subject.onNext(error)
    }

    deinit {
        _subject.onCompleted()
    }
}

public extension ObservableConvertibleType {
    func trackError(_ errorTracker: ErrorTracker) -> Observable<E> {
        return errorTracker.trackError(from: self)
    }
}

// MARK: Input Validation
extension ErrorTracker {
    func asInputErrors<IE: InputError>(mapError: @escaping (Swift.Error) -> IE?) -> Driver<IE> {
        return asObservable().materialize().map { (event: Event<Error>) -> IE? in
            guard case .next(let swiftError) = event else {
                return nil
            }

            guard let mappedError = mapError(swiftError) else {
                GlobalTracker.shared.track(error: .failedToMapSwiftErrorTo(type: IE.self))
                return nil
            }

            return mappedError
        }
        .filterNil()
        // This is an Driver of Errors, so it is correct to call `asDriverOnErrorReturnEmpty`, which will not filter out our elements (errors).
        .asDriverOnErrorReturnEmpty()
    }

    func asInputValidationErrors<IE: InputError>(mapError: @escaping (Swift.Error) -> IE?) -> Driver<Validation> {
        return asInputErrors(mapError: mapError)
            .map { $0.errorMessage }
            .map { .error(errorMessage: $0) }
    }
}
