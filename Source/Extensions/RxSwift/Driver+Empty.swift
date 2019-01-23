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
    func onlyErrors() -> Driver<AnyValidation> {
        return map { $0.validation }
            .map { $0.isError ? $0 : nil }
            .filterNil()
    }

    func nonErrors() -> Driver<AnyValidation> {
        return map { $0.validation }
            .map { !$0.isError ? $0 : nil }
            .filterNil()
    }
}
