//
//  AbstractTarget.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-04.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AbstractTarget {
    private unowned let triggerSubject: PublishSubject<Void>
    init(triggerSubject: PublishSubject<Void>) {
        self.triggerSubject = triggerSubject
    }

    @objc func pressed() {
        triggerSubject.onNext(())
    }
}
