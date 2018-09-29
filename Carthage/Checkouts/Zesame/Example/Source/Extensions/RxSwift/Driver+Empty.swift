//
//  Driver+Empty.swift
//  ZesameiOSExample
//
//  Created by Alexander Cyon on 2018-09-28.
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

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
