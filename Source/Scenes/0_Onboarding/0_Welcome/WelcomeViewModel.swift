//
//  WelcomeViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-19.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - User action and navigation steps
enum WelcomeUserAction: TrackedUserAction {
    case /*user intends to*/start
}

final class WelcomeViewModel: BaseViewModel<
    WelcomeUserAction,
    WelcomeViewModel.InputFromView,
    WelcomeViewModel.Output
> {

    override func transform(input: Input) -> Output {
        func userIntends(to userAction: NavigationStep) {
            navigator.next(userAction)
        }

        // MARK: Navigate
        bag <~ [
            input.fromView.startTrigger
                .do(onNext: { userIntends(to: .start) })
                .drive()
        ]

        return Output()
    }
}

extension WelcomeViewModel {
    
    struct InputFromView {
        let startTrigger: Driver<Void>
    }

    struct Output {}
}
