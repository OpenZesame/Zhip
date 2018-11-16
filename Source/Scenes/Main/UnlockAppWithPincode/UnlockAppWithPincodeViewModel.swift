//
//  UnlockAppWithPincodeViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

private typealias € = L10n.Scene.UnlockAppWithPincode.Title

enum UnlockAppWithPincodeNavigation: TrackedUserAction {
    case userFinished
}

final class UnlockAppWithPincodeViewModel: BaseViewModel<
    UnlockAppWithPincodeNavigation,
    UnlockAppWithPincodeViewModel.InputFromView,
    UnlockAppWithPincodeViewModel.Output
> {

    private let useCase: PincodeUseCase
    private let userWantsToRemovePincode: Bool

    init(useCase: PincodeUseCase, userWantsToRemovePincode: Bool) {
        self.useCase = useCase
        self.userWantsToRemovePincode = userWantsToRemovePincode
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {

        if isSkippable {
            input.fromController.rightBarButtonContentSubject.onBarButton(.skip)

            bag <~ input.fromController.rightBarButtonTrigger.do(onNext: { [unowned stepper] in
                stepper.step(.userFinished)
            }).drive()
        }

        input.fromController.titleSubject.onNext(userWantsToRemovePincode ? €.removePincode : €.resumeApp)

        let matchingPincode = input.fromView.pincode.map { [unowned useCase] (pincode: Pincode?) -> Bool in
            guard let pincode = pincode else { return false }
            return useCase.doesPincodeMatchChosen(pincode)
            }.filter { $0 }.mapToVoid()

        bag <~ [
            matchingPincode.do(onNext: { [unowned self] in
                func finish() {
                    self.stepper.step(.userFinished)
                }
                if self.userWantsToRemovePincode {
                    self.useCase.deletePincode()
                    let tost = Toast(L10n.Flow.Pincode.Event.Toast.didRemovePincode) {
                        finish()
                    }
                    input.fromController.toastSubject.onNext(tost)
                } else {
                    finish()
                }
            }).drive()
        ]

        return Output()
    }
}

extension UnlockAppWithPincodeViewModel {
    struct InputFromView {
        let pincode: Driver<Pincode?>
    }

    struct Output {}

}

private extension UnlockAppWithPincodeViewModel {
    var isSkippable: Bool {
        return userWantsToRemovePincode
    }
}
