//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - User action and navigation steps
enum WelcomeUserAction: String, TrackedUserAction {
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
