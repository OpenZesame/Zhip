//
//  ManagePincodeCoordinator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-14.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

final class ManagePincodeCoordinator: BaseCoordinator<ManagePincodeCoordinator.Step> {
    enum Step {
        case finish
    }
    enum Intent {
        case setPincode
        case unlockApp
        case removePincode
    }

    private let useCase: PincodeUseCase
    private let intent: Intent

    init(intent: Intent, presenter: Presenter?, useCase: PincodeUseCase) {
        self.useCase = useCase
        self.intent = intent
        super.init(presenter: presenter)
        toNextStep()
    }

    override func start() {}
}

// MARK: Private
private extension ManagePincodeCoordinator {

    func toNextStep() {
        guard useCase.hasConfiguredPincode else { return toChoosePincode() }

        switch intent {
        case .unlockApp: toUnlockApp()
        case .removePincode: toRemovePincode()
        case .setPincode:
            incorrectImplementation("Changing a pincode is not supported, make changes in UI so that user need to remove wallet first, then present user with the option to set a (new) pincode.")
        }

    }

    func toUnlockApp() {
        let viewModel = UnlockAppWithPincodeViewModel(useCase: useCase)
        present(type: UnlockAppWithPincode.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .unlockApp: self.finish()
            }
        }
    }

    func toRemovePincode() {
        let viewModel = RemovePincodeViewModel(useCase: useCase)
        present(type: RemovePincode.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .cancelPincodeRemoval, .removePincode: self.finish()
            }
        }
    }

    func toChoosePincode() {
        present(type: ChoosePincode.self, viewModel: ChoosePincodeViewModel(), configureNavigationItem: {
            $0.hidesBackButton = true
        }, navigationHandler: { [unowned self] userDid in
            switch userDid {
            case .chosePincode(let unconfirmedPincode): self.toConfirmPincode(unconfirmedPincode: unconfirmedPincode)
            case .skip: self.skipPincode()
            }
        })
    }

    func toConfirmPincode(unconfirmedPincode: Pincode) {
        let viewModel = ConfirmNewPincodeViewModel(useCase: useCase, confirm: unconfirmedPincode)
        present(type: ConfirmNewPincode.self, viewModel: viewModel) { [unowned self] userDid in
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
        stepper.step(.finish)
    }
}
