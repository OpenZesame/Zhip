//
//  Driver+Empty.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public extension ObservableType {

    func catchErrorReturnEmpty() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }

    func asDriverOnErrorReturnEmpty() -> Driver<E> {
        return asDriver { _ in
            return Driver.empty()
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { error in
            return Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    func mapToVoid() -> Driver<Void> {
        return map { _ in }
    }
}

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, E: ValidationConvertible {
    func onlyErrorsAndWarnings() -> Driver<AnyValidation> {
        return map { $0.validation }
            .map { $0.isErrorOrWarning ? $0 : nil }
            .filterNil()
    }

    func onlyValidOrEmpty() -> Driver<AnyValidation> {
        return map { $0.validation }
            .map { $0.isValidOrEmpty ? $0 : nil }
            .filterNil()
    }
}
