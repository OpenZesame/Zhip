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
