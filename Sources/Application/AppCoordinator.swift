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

enum AppCoordinatorNavigationStep {}

final class AppCoordinator: BaseCoordinator<AppCoordinatorNavigationStep> {

    private let useCaseProvider: UseCaseProvider
    private let deepLinkHandler: DeepLinkHandler

    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
    private lazy var pincodeUseCase = useCaseProvider.makePincodeUseCase()
    private lazy var lockAppScene = LockAppScene()
   
    private lazy var unlockAppScene: UnlockAppWithPincode = {
        let viewModel = UnlockAppWithPincodeViewModel(useCase: pincodeUseCase)
        let scene = UnlockAppWithPincode(viewModel: viewModel)
        
        self.bag <~ scene.viewModel.navigator.navigation
            .asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .do(onNext: { [weak self] userDid in
                switch userDid {
                case .unlockApp:
                    self?.appIsUnlockedEmitBufferedDeeplinks()
                    self?.restoreMainNavigationStack()
                }
            })
            .asDriverOnErrorReturnEmpty()
            .drive()
        return scene
    }()

    private let __setRootViewControllerOfWindow: (UIViewController) -> Void
    private let isViewControllerRootOfWindow: (UIViewController) -> Bool
    
    init(
        navigationController: UINavigationController,
        deepLinkHandler: DeepLinkHandler,
        useCaseProvider: UseCaseProvider,
        isViewControllerRootOfWindow: @escaping (UIViewController) -> Bool,
        setRootViewControllerOfWindow: @escaping (UIViewController) -> Void
    ) {
        self.deepLinkHandler = deepLinkHandler
        self.useCaseProvider = useCaseProvider
        self.__setRootViewControllerOfWindow = setRootViewControllerOfWindow
        self.isViewControllerRootOfWindow = isViewControllerRootOfWindow
        super.init(navigationController: navigationController)
    }

    override func start(didStart: Completion? = nil) {
        if walletUseCase.hasConfiguredWallet {
            toMain(displayUnlockSceneIfNeeded: true)
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

    func toMain(displayUnlockSceneIfNeeded displayUnlockScene: Bool = false) {

        let main = MainCoordinator(
            navigationController: navigationController,
            deepLinkGenerator: DeepLinkGenerator(),
            useCaseProvider: useCaseProvider,
            deeplinkedTransaction: deepLinkHandler.navigation.map { $0.asTransaction }.filterNil()
        )

        start(coordinator: main, transition: .replace, didStart: { [unowned self] in
                if displayUnlockScene {
                    self.toUnlockAppWithPincodeIfNeeded()
                }
            }, navigationHandler: { [unowned self] userDid in
                switch userDid {
                case .removeWallet: self.toOnboarding()
                }
        })
    }
    
    var hasConfiguredPincode: Bool {
        return pincodeUseCase.hasConfiguredPincode
    }
    
    func toUnlockAppWithPincodeIfNeeded() {
        
        guard hasConfiguredPincode, !isCurrentlyPresentingUnLockScene else {
            return
        }
        
        setRootViewControllerOfWindow(to: unlockAppScene)
    }
}

private extension AppCoordinator {
    
    func restoreMainNavigationStack() {
        setRootViewControllerOfWindow(to: navigationController)
    }
    
    func setRootViewControllerOfWindow(to viewController: UIViewController) {
        __setRootViewControllerOfWindow(viewController)
    }
}

// MARK: - Lock app with pincode
extension AppCoordinator {
    
    func appWillResignActive() {
        lockApp()
    }
    
    func appDidBecomeActive() {
        unlockApp()
    }
}

// MARK: - Private Lock app with pincode
private extension AppCoordinator {
    
    func lockApp() {
        if isCurrentlyPresentingUnLockScene || isCurrentlyPresentingLockScene {
            return
        }
        deepLinkHandler.appIsLockedBufferDeeplinks()
        setRootViewControllerOfWindow(to: lockAppScene)
    }
    
    func unlockApp() {
        if isCurrentlyPresentingUnLockScene { return }
        guard isCurrentlyPresentingLockScene else { return }
        if hasConfiguredPincode {
            toUnlockAppWithPincodeIfNeeded()
        } else {
            restoreMainNavigationStack()
            appIsUnlockedEmitBufferedDeeplinks()
        }
    }

    var isCurrentlyPresentingUnLockScene: Bool {
        guard hasConfiguredPincode else { return false }
        return isViewControllerRootOfWindow(unlockAppScene)
    }
    
    var isCurrentlyPresentingLockScene: Bool {
        return isViewControllerRootOfWindow(lockAppScene)
    }
    
    func appIsUnlockedEmitBufferedDeeplinks(delayInSeconds: TimeInterval = 0.2) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) { [weak self] in
            self?.deepLinkHandler.appIsUnlockedEmitBufferedDeeplinks()
        }
    }
}

// MARK: - DeepLink Handler
extension AppCoordinator {

    /// returns: `true` if the delegate successfully handled the request or `false` if the attempt to open the URL resource failed.
    func handleDeepLink(_ url: URL) -> Bool {
        return deepLinkHandler.handle(url: url)
    }
}
