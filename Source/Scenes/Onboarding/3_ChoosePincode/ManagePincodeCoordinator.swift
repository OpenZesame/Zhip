//
//  ManagePincodeCoordinator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-14.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

final class ManagePincodeCoordinator: AbstractCoordinator<ManagePincodeCoordinator.Step> {
    enum Step {
        case userFinishedChoosingOrRemovingPincode
    }
    enum Intent {
        case setPincode
        case unlockApp(toRemovePincode: Bool)
    }

    private let useCase: PincodeUseCase
    private let intent: Intent

    init(intent: Intent, presenter: Presenter?, useCase: PincodeUseCase) {
        self.useCase = useCase
        self.intent = intent
        super.init(presenter: presenter)
    }

    override func start() {
        if useCase.hasConfiguredPincode {
            switch intent {
            case .unlockApp: toConfirmExisting()
            case .setPincode:
                incorrectImplementation("Changing a pincode is not supported, make changes in UI so that user need to remove wallet first, then present user with the option to set a (new) pincode.")
            }
        } else {
            switch intent {
            case .setPincode: toChoosePincode()
            case .unlockApp:
                incorrectImplementation("Never ever lock the app if the user has not set a pincode. That would shut them out from their wallet")
            }
        }
    }
}

// MARK: Private
private extension ManagePincodeCoordinator {

    func toConfirmExisting() {
        let viewModel = UnlockAppWithPincodeViewModel(useCase: useCase, userWantsToRemovePincode: intent.userWantsToRemovePincode)
        present(type: UnlockAppWithPincode.self, viewModel: viewModel) { [unowned self] in
            switch $0 {
            case .userAbortedRemovalOfPin, .userDidUnlockApp, .userRemovedPincode: self.finish()
            }
        }
    }

    func toChoosePincode() {
        present(type: ChoosePincode.self, viewModel: ChoosePincodeViewModel(), configureNavigationItem: {
            $0.hidesBackButton = true
        }, navigationHandler: { [unowned self] in
            switch $0 {
            case .userChoseUnconfirmedPincode(let unconfirmedPincode): self.toConfirmPincode(unconfirmedPincode: unconfirmedPincode)
            case .userWannaSkipChoosingPincode: self.skipPincode()
            }
        })
    }

    func toConfirmPincode(unconfirmedPincode: Pincode) {
        let viewModel = ConfirmNewPincodeViewModel(useCase: useCase, confirm: unconfirmedPincode)
        present(type: ConfirmNewPincode.self, viewModel: viewModel) { [unowned self] in
            switch $0 {
            case .userWannaSkipChoosingPincode: self.skipPincode()
            case .userFinishedChoosingPincode: self.finish()
            }
        }
    }

    func skipPincode() {
        useCase.skipSettingUpPincode()
        finish()
    }

    func finish() {
        stepper.step(.userFinishedChoosingOrRemovingPincode)
    }
}

extension ManagePincodeCoordinator.Intent {
    var userWantsToRemovePincode: Bool {
        switch self {
        case .unlockApp(let toRemovePincode): return toRemovePincode
        case .setPincode: return false
        }
    }
}
