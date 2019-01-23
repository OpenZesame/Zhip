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

import UIKit

final class SetPincodeCoordinator: BaseCoordinator<SetPincodeCoordinator.NavigationStep> {
    enum NavigationStep {
        case setPincode
    }

    private let useCase: PincodeUseCase

    init(navigationController: UINavigationController, useCase: PincodeUseCase) {
        self.useCase = useCase
        super.init(navigationController: navigationController)
    }

    override func start(didStart: Completion? = nil) {
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

        push(scene: ChoosePincode.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .chosePincode(let unconfirmedPincode): self.toConfirmPincode(unconfirmedPincode: unconfirmedPincode)
            case .skip: self.skipPincode()
            }
        }
    }

    func toConfirmPincode(unconfirmedPincode: Pincode) {
        let viewModel = ConfirmNewPincodeViewModel(useCase: useCase, confirm: unconfirmedPincode)

        push(scene: ConfirmNewPincode.self, viewModel: viewModel) { [unowned self] userDid in
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
        navigator.next(.setPincode)
    }
}
