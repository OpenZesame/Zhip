//
//  SetPincodeCoordinator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-14.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

final class SetPincodeCoordinator: BaseCoordinator<SetPincodeCoordinator.Step> {
    enum Step {
        case setPincode
    }

    private let useCase: PincodeUseCase

    init(presenter: UINavigationController, useCase: PincodeUseCase) {
        self.useCase = useCase
        super.init(presenter: presenter)
    }

    override func start() {
        guard !useCase.hasConfiguredPincode else {
            incorrectImplementation("Changing a pincode is not supported, make changes in UI so that user need to remove wallet first, then present user with the option to set a (new) pincode.")
        }

        toChoosePincode()
    }
}

// MARK: Private
private extension SetPincodeCoordinator {

    func toChoosePincode() {
        let viewModel = ChoosePincodeViewModel()

        push(scene: ChoosePincode.self, viewModel: viewModel) { [unowned self] userDid, _ in
            switch userDid {
            case .chosePincode(let unconfirmedPincode): self.toConfirmPincode(unconfirmedPincode: unconfirmedPincode)
            case .skip: self.skipPincode()
            }
        }
    }

    func toConfirmPincode(unconfirmedPincode: Pincode) {
        let viewModel = ConfirmNewPincodeViewModel(useCase: useCase, confirm: unconfirmedPincode)

        push(scene: ConfirmNewPincode.self, viewModel: viewModel) { [unowned self] userDid, _ in
            switch userDid {
            case .skip: self.skipPincode()
            case .confirmPincode: self.finish()
            }
        }
    }

    func skipPincode() {
        useCase.skipSettingUpPincode()
        finish()
    }

    func finish() {
        stepper.step(.setPincode)
    }
}
