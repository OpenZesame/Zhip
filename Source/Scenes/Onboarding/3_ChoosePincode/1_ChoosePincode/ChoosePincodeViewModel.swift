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

enum ChoosePincodeNavigation: TrackedUserAction {
    case userChoseUnconfirmedPincode(Pincode)
    case userWannaSkipChoosingPincode
}

final class ChoosePincodeViewModel: BaseViewModel<
    ChoosePincodeNavigation,
    ChoosePincodeViewModel.InputFromView,
    ChoosePincodeViewModel.Output
> {

    override func transform(input: Input) -> Output {

        let pincode = input.fromView.pincode

        bag <~ [
            input.fromView.confirmedTrigger.withLatestFrom(pincode.filterNil())
            .do(onNext: { [unowned self] in
                self.stepper.step(.userChoseUnconfirmedPincode($0))
            }).drive(),

            input.fromController.rightBarButtonTrigger.do(onNext: { [unowned stepper] in
                stepper.step(.userWannaSkipChoosingPincode)
            }).drive()
        ]

        return Output(
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
        let isConfirmPincodeEnabled: Driver<Bool>
    }

}
