//
//  EnsureThatYouAreNotBeingWatchedViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-22.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - User action and navigation steps
enum EnsureThatYouAreNotBeingWatchedUserAction: TrackedUserAction {
    case /*user did*/understand, cancel
}

// MARK: - EnsureThatYouAreNotBeingWatchedViewModel
private typealias € = L10n.Scene.EnsureThatYouAreNotBeingWatched

final class EnsureThatYouAreNotBeingWatchedViewModel: BaseViewModel<
    EnsureThatYouAreNotBeingWatchedUserAction,
    EnsureThatYouAreNotBeingWatchedViewModel.InputFromView,
    EnsureThatYouAreNotBeingWatchedViewModel.Output
> {

    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        // MARK: Navigate
        bag <~ [
            input.fromController.leftBarButtonTrigger
                .do(onNext: { userDid(.cancel) })
                .drive(),

            input.fromView.understandTrigger
                .do(onNext: { userDid(.understand) })
                .drive()
        ]

        return Output()
    }
}

extension EnsureThatYouAreNotBeingWatchedViewModel {
    
    struct InputFromView {
        let understandTrigger: Driver<Void>
    }

    struct Output {}
}
