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

    func asInputValidationErrors<IE: InputError>(mapError: @escaping (Swift.Error) -> IE?) -> Driver<AnyValidation> {
        return asInputErrors(mapError: mapError)
            .map { $0.errorMessage }
            .map { .errorMessage($0) }
    }
}
