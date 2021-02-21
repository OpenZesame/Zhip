// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit

enum SetPincodeCoordinatorNavigationStep {
    case setPincode
}

final class SetPincodeCoordinator: BaseCoordinator<SetPincodeCoordinatorNavigationStep> {
  
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
