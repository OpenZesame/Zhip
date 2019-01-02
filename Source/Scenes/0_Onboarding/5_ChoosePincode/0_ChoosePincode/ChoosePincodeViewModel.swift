//
//  ChoosePincodeViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum ChoosePincodeUserAction: TrackableEvent {
    case chosePincode(Pincode)
    case skip

    var eventName: String {
        switch self {
        case .chosePincode: return "chosePincode"
        case .skip: return "skip"
        }
    }
}

final class ChoosePincodeViewModel: BaseViewModel<
    ChoosePincodeUserAction,
    ChoosePincodeViewModel.InputFromView,
    ChoosePincodeViewModel.Output
> {

    override func transform(input: Input) -> Output {
        func userDid(_ step: NavigationStep) {
            navigator.next(step)
        }

        let pincode = input.fromView.pincode

        bag <~ [
            input.fromView.doneTrigger.withLatestFrom(pincode.filterNil())
            .do(onNext: { userDid(.chosePincode($0)) })
                .drive(),

            input.fromController.rightBarButtonTrigger
                .do(onNext: { userDid(.skip) })
                .drive()
        ]

        return Output(
            inputBecomeFirstResponder: input.fromController.viewWillAppear,
            isDoneButtonEnabled: pincode.map { $0 != nil }
        )
    }
}

extension ChoosePincodeViewModel {
    struct InputFromView {
        let pincode: Driver<Pincode?>
        let doneTrigger: Driver<Void>
    }

    struct Output {
        let inputBecomeFirstResponder: Driver<Void>
        let isDoneButtonEnabled: Driver<Bool>
    }

}
