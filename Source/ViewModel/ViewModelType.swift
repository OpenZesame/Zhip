//
//  ViewModelType.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ControllerInput {
    let viewDidLoad: Driver<Void>
    let viewWillAppear: Driver<Void>
    let viewDidAppear: Driver<Void>
    let rightBarButtonTrigger: Driver<Void>
    let toastSubject: PublishSubject<Toast>
}

protocol InputType {
    associatedtype FromView
    var fromView: FromView { get }
    var fromController: ControllerInput { get }
    init(fromView: FromView, fromController: ControllerInput)
}

extension InputType {
    var fromController: ControllerInput { fatalError("implement me") }
}

protocol ViewModelType {
    associatedtype Input: InputType
    associatedtype Output
    func transform(input: Input) -> Output
}
