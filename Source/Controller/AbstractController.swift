//
//  AbstractController.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AbstractController: UIViewController {
    let rightBarButtonSubject = PublishSubject<Void>()
    let leftBarButtonSubject = PublishSubject<Void>()
    lazy var rightBarButtonAbtractTarget = AbstractTarget(triggerSubject: rightBarButtonSubject)
    lazy var leftBarButtonAbtractTarget = AbstractTarget(triggerSubject: leftBarButtonSubject)
}
