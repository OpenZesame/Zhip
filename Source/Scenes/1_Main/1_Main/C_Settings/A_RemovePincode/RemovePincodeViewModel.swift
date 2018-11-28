//
//  RemovePincodeViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

// MARK: - RemovePincodeUserAction
enum RemovePincodeUserAction: TrackedUserAction {
    case cancelPincodeRemoval
    case removePincode
}

// MARK: - RemovePincodeViewModel
private typealias € = L10n.Scene.RemovePincode
final class RemovePincodeViewModel: BaseViewModel<
    RemovePincodeUserAction,
    RemovePincodeViewModel.InputFromView,
    RemovePincodeViewModel.Output
> {

    private let useCase: PincodeUseCase

    init(useCase: PincodeUseCase) {
        self.useCase = useCase
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        let matchingPincode = input.fromView.pincode.map { [unowned useCase] in
            useCase.doesPincodeMatchChosen($0)
            }.filter { $0 }.mapToVoid()

        bag <~ [
            input.fromController.leftBarButtonTrigger.do(onNext: {
                userDid(.cancelPincodeRemoval)
            }).drive(),

            matchingPincode.do(onNext: { [unowned useCase] in
                useCase.deletePincode()
                let toast = Toast(€.Event.Toast.didRemovePincode) {
                    userDid(.removePincode)
                }
                input.fromController.toastSubject.onNext(toast)

            }).drive()
        ]

        return Output()
    }
}

extension RemovePincodeViewModel {
    struct InputFromView {
        let pincode: Driver<Pincode?>
    }

    struct Output {}
}
