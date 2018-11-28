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

// MARK: - UnlockAppWithPincodeUserAction
enum UnlockAppWithPincodeUserAction: TrackedUserAction {
    case unlockApp
}

// MARK: - UnlockAppWithPincodeViewModel
private typealias € = L10n.Scene.UnlockAppWithPincode
final class UnlockAppWithPincodeViewModel: BaseViewModel<
    UnlockAppWithPincodeUserAction,
    UnlockAppWithPincodeViewModel.InputFromView,
    UnlockAppWithPincodeViewModel.Output
> {

    private let useCase: PincodeUseCase

    init(useCase: PincodeUseCase) {
        self.useCase = useCase
    }

    override func transform(input: Input) -> Output {
        func userDid(_ userAction: Step) {
            navigator.next(userAction)
        }

        let matchingPincode = input.fromView.pincode.map { [unowned useCase] in
            useCase.doesPincodeMatchChosen($0)
        }.filter { $0 }.mapToVoid()

        bag <~ matchingPincode.do(onNext: { userDid(.unlockApp) }).drive()

        return Output(
            inputBecomeFirstResponder: input.fromController.viewWillAppear
        )
    }
}

extension UnlockAppWithPincodeViewModel {
    struct InputFromView {
        let pincode: Driver<Pincode?>
    }

    struct Output {
        let inputBecomeFirstResponder: Driver<Void>
    }
}
