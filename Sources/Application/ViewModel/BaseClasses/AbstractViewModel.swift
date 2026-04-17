// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import Foundation

class AbstractViewModel<FromView, FromController, OutputFromViewModel>: ViewModelType {
    let bag = CancellableBag()

    struct Input: InputType {
        let fromController: FromController
        let fromView: FromView

        init(fromView: FromView, fromController: FromController) {
            self.fromView = fromView
            self.fromController = fromController
        }
    }

    func transform(input _: Input) -> OutputFromViewModel {
        abstract
    }
}
