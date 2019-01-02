//
//  BaseViewModel_Test_Extenions.swift
//  ZhipTests
//
//  Created by Alexander Cyon on 2018-12-18.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

@testable import Zhip
import RxSwift
import RxCocoa

extension ViewModelType where Input: InputType, Self.Input.FromController == InputFromController {
    func transform(inputFromView: Input.FromView) -> Output {
        let input = Input.init(fromView: inputFromView, fromController: .empty)
        return transform(input: input)
    }
}

private extension InputFromController {
    static var empty: InputFromController {
        return InputFromController(
            viewDidLoad: .empty(),
            viewWillAppear: .empty(),
            viewDidAppear: .empty(),
            leftBarButtonTrigger: .empty(),
            rightBarButtonTrigger: .empty(),
            titleSubject: PublishSubject<String>(),
            leftBarButtonContentSubject: PublishSubject<BarButtonContent>(),
            rightBarButtonContentSubject: PublishSubject<BarButtonContent>(),
            toastSubject: PublishSubject<Toast>()
        )
    }
}
