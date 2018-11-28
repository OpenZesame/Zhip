//
//  InputFromController.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-14.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct InputFromController {

    let viewDidLoad: Driver<Void>
    let viewWillAppear: Driver<Void>
    let viewDidAppear: Driver<Void>

    let leftBarButtonTrigger: Driver<Void>
    let rightBarButtonTrigger: Driver<Void>

    let titleSubject: PublishSubject<String>
    let leftBarButtonContentSubject: PublishSubject<BarButtonContent>
    let rightBarButtonContentSubject: PublishSubject<BarButtonContent>
    let toastSubject: PublishSubject<Toast>
}
