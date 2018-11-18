//
//  ChoosePincodeViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum ChoosePincodeUserAction: TrackedUserAction {
    case chosePincode(Pincode)
    case skip
}

final class ChoosePincodeViewModel: BaseViewModel<
    ChoosePincodeUserAction,
    ChoosePincodeViewModel.InputFromView,
    ChoosePincodeViewModel.Output
> {

    override func transform(input: Input) -> Output {

        let pincode = input.fromView.pincode

        bag <~ [
            input.fromView.confirmedTrigger.withLatestFrom(pincode.filterNil())
            .do(onNext: { [unowned self] in
                self.stepper.step(.chosePincode($0))
            }).drive(),

            input.fromController.rightBarButtonTrigger.do(onNext: { [unowned stepper] in
                stepper.step(.skip)
            }).drive()
        ]

        return Output(
            inputBecomeFirstResponder: input.fromController.viewWillAppear,
            isConfirmPincodeEnabled: pincode.map { $0 != nil }
        )
    }
}

extension ChoosePincodeViewModel {
    struct InputFromView {
        let pincode: Driver<Pincode?>
        let confirmedTrigger: Driver<Void>
    }

    struct Output {
        let inputBecomeFirstResponder: Driver<Void>
        let isConfirmPincodeEnabled: Driver<Bool>
    }

}
