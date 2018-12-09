//
//  BaseViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AbstractViewModel<FromView, FromController, Output>: ViewModelType {
    let bag = DisposeBag()

    struct Input: InputType {

        let fromController: FromController
        let fromView: FromView

        init(fromView: FromView, fromController: FromController) {
            self.fromView = fromView
            self.fromController = fromController
        }
    }

    func transform(input: Input) -> Output { abstract }
}
