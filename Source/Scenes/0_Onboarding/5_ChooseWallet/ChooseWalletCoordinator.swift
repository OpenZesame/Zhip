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
import RxSwift
import Zesame

enum ChooseWalletCoordinatorNavigationStep {
    case finishChoosingWallet
}

final class ChooseWalletCoordinator: BaseCoordinator<ChooseWalletCoordinatorNavigationStep> {

    private let useCaseProvider: UseCaseProvider
    private lazy var useCase = useCaseProvider.makeWalletUseCase()

    init(navigationController: UINavigationController, useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(navigationController: navigationController)
    }

    override func start(didStart: Completion? = nil) {
        toChooseWallet()
    }
}

// MARK: Private
private extension ChooseWalletCoordinator {

    func toChooseWallet() {
        let viewModel = ChooseWalletViewModel()

        push(scene: ChooseWallet.self, viewModel: viewModel) { [unowned self] userIntendsTo in
            switch userIntendsTo {
            case .createNewWallet: self.toCreateNewWallet()
            case .restoreWallet: self.toRestoreWallet()
            }
        }
    }

    func toCreateNewWallet() {
        presentModalCoordinator(
            makeCoordinator: { CreateNewWalletCoordinator(navigationController: $0, useCaseProvider: useCaseProvider) },
            navigationHandler: { [unowned self] userDid, dismissFlow in
                defer { dismissFlow(true) }
                switch userDid {
                case .create(let wallet): self.userFinishedChoosing(wallet: wallet)
                case .cancel: break
                }
        })
    }

    func toRestoreWallet() {
        presentModalCoordinator(
            makeCoordinator: { RestoreWalletCoordinator(navigationController: $0, useCase: useCase) },
            navigationHandler: { [unowned self] userDid, dismissFlow in
                defer { dismissFlow(true) }
                switch userDid {
                case .finishedRestoring(let wallet): self.userFinishedChoosing(wallet: wallet)
                case .cancel: break
                }
        })
    }

    func userFinishedChoosing(wallet: Wallet) {
        useCase.save(wallet: wallet)
        navigator.next(.finishChoosingWallet)
    }
}
