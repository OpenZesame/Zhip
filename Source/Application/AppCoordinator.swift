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

final class AppCoordinator: BaseCoordinator<AppCoordinator.NavigationStep> {
    enum NavigationStep {}

    private let useCaseProvider: UseCaseProvider
    private let deepLinkHandler: DeepLinkHandler

    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
    private lazy var pincodeUseCase = useCaseProvider.makePincodeUseCase()

    init(navigationController: UINavigationController, deepLinkHandler: DeepLinkHandler, useCaseProvider: UseCaseProvider) {
        self.deepLinkHandler = deepLinkHandler
        self.useCaseProvider = useCaseProvider

        super.init(navigationController: navigationController)
    }

    override func start(didStart: Completion? = nil) {
		if walletUseCase.hasConfiguredWallet {
            toMain(lockIfNeeded: true)
        } else {
            toOnboarding()
        }
    }
}

// MARK: - Private
private extension AppCoordinator {

    func toOnboarding() {

        let onboarding = OnboardingCoordinator(
            navigationController: navigationController,
            useCaseProvider: useCaseProvider
        )

        start(coordinator: onboarding, transition: .replace) { [unowned self] userDid in
            switch userDid {
            case .finishOnboarding: self.toMain()
            }
        }
    }

    func toMain(lockIfNeeded lock: Bool = false) {

        let main = MainCoordinator(
            navigationController: navigationController,
            deepLinkGenerator: DeepLinkGenerator(),
            useCaseProvider: useCaseProvider,
            deeplinkedTransaction: deepLinkHandler.navigation.map { $0.asTransaction }.filterNil()
        )

        start(coordinator: main, transition: .replace, didStart: { [unowned self] in
                if lock {
                    self.lockApp()
                }
            }, navigationHandler: { [unowned self] userDid in
                switch userDid {
                case .removeWallet: self.toOnboarding()
                }
        })
    }

    func toUnlockAppWithPincodeIfNeeded() {
        guard pincodeUseCase.hasConfiguredPincode, !isCurrentlyPresentingLockScene else { return }

        let viewModel = UnlockAppWithPincodeViewModel(useCase: pincodeUseCase)

        deepLinkHandler.appIsLockedBufferDeeplinks()

        topMostCoordinator.modallyPresent(
            scene: UnlockAppWithPincode.self,
            viewModel: viewModel
        ) { [unowned self] userDid, dismissScene in
            switch userDid {
            case .unlockApp:
                dismissScene(true, { [unowned self] in
                    self.deepLinkHandler.appIsUnlockedEmitBufferedDeeplinks()
                })
            }
        }
    }
}

// MARK: - Lock app with pincode
extension AppCoordinator {
    func appWillResignActive() {
        lockApp()
    }
}

// MARK: - Private Lock app with pincode
private extension AppCoordinator {
    func lockApp() {
        toUnlockAppWithPincodeIfNeeded()
    }

    var isCurrentlyPresentingLockScene: Bool {
        return topMostScene is UnlockAppWithPincode
    }
}

// MARK: - DeepLink Handler
extension AppCoordinator {

    /// returns: `true` if the delegate successfully handled the request or `false` if the attempt to open the URL resource failed.
    func handleDeepLink(_ url: URL) -> Bool {
        return deepLinkHandler.handle(url: url)
    }
}
