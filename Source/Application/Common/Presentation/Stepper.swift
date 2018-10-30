//
//  Stepper.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-27.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class Stepper<Step> {
    private let navigator: PublishSubject<Step>
    func step(_ step: Step) {
        navigator.onNext(step)
    }
    var navigation: Driver<Step> {
        return navigator.asDriverOnErrorReturnEmpty()
    }

    init(publishSubject: PublishSubject<Step> = PublishSubject<Step>()) {
        self.navigator = publishSubject
    }
}
