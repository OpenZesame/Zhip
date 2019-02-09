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
import RxCocoa
import Zesame

final class ReceiveCoordinator: BaseCoordinator<ReceiveCoordinator.NavigationStep> {
    enum NavigationStep {
        case finish
    }

    private let deepLinkGenerator: DeepLinkGenerator
    private let useCaseProvider: UseCaseProvider
    private let walletUseCase: WalletUseCase
    private let onboardingUseCase: OnboardingUseCase

    init(navigationController: UINavigationController, useCaseProvider: UseCaseProvider, deepLinkGenerator: DeepLinkGenerator) {
        self.useCaseProvider = useCaseProvider
        self.walletUseCase = useCaseProvider.makeWalletUseCase()
        self.onboardingUseCase = useCaseProvider.makeOnboardingUseCase()
        self.deepLinkGenerator = deepLinkGenerator
        super.init(navigationController: navigationController)
    }

    override func start(didStart: Completion? = nil) {
        toFirst()
    }
}

// MARK: - Navigate
private extension ReceiveCoordinator {

    func toFirst() {
        guard useCaseProvider.makeOnboardingUseCase().hasAskedToSkipERC20Warning else {
            return toWarningERC20()
        }

        toReceive()
    }

    func toWarningERC20() {
        let viewModel = WarningERC20ViewModel(
            useCase: onboardingUseCase,
            mode: .userHaveToAccept(isDoNotShowAgainButtonVisible: true)
        )

        push(scene: WarningERC20.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .understandRisks, .dismiss: self.toReceive()
            }
        }
    }
    func toReceive() {
        let viewModel = ReceiveViewModel(useCase: walletUseCase)

        push(scene: Receive.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .requestTransaction(let requestedTransaction): self.share(transaction: requestedTransaction)
            case .finish: self.finish()
            }
        }
    }

    func finish() {
        navigator.next(.finish)
    }
}

// MARK: - Share
private extension ReceiveCoordinator {
    func share(transaction: TransactionIntent) {
        let shareUrl = deepLinkGenerator.linkTo(transaction: transaction)
        let activityVC = UIActivityViewController(activityItems: [shareUrl], applicationActivities: nil)
        activityVC.modalPresentationStyle = .popover
        activityVC.popoverPresentationController?.barButtonItem = navigationController.navigationItem.rightBarButtonItem
        navigationController.present(activityVC, animated: true, completion: nil)
    }
}
