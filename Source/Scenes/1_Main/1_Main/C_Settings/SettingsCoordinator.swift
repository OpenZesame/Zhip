//
//  SettingsCoordinator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Zesame

final class SettingsCoordinator: BaseCoordinator<SettingsCoordinator.Step> {
    enum Step {
        case removeWallet
        case closeSettings
    }

    private let useCaseProvider: UseCaseProvider
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
    private lazy var pincodeUseCase = useCaseProvider.makePincodeUseCase()

    init(presenter: UINavigationController?, useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(presenter: presenter)
    }

    override func start() {
        toSettings()
    }
}

// MARK: - Navigate
private extension SettingsCoordinator {

    func toSettings() {
        let viewModel = SettingsViewModel(useCase: pincodeUseCase)
        present(scene: Settings.self, viewModel: viewModel, presentation: .none) { [unowned self] userIntendsTo in
            switch userIntendsTo {
            case .closeSettings: self.finish()
            case .setPincode: self.toSetPincode()
            case .removePincode: self.toRemovePincode()
            case .backupWallet: self.toBackupWallet()
            case .removeWallet: self.toChooseWallet()
            }
        }
    }

    func toSetPincode() {
        toPincode(intent: .setPincode)
    }

    func toRemovePincode() {
        toPincode(intent: .removePincode)
    }

    func toChooseWallet() {
        walletUseCase.deleteWallet()
        pincodeUseCase.deletePincode()
        userIntends(to: .removeWallet)
    }

    func toBackupWallet() {
        let wallet = walletUseCase.wallet.asDriverOnErrorReturnEmpty().map { (wallet: Wallet?) -> Wallet in
            guard let wallet = wallet else { incorrectImplementation("Should have a wallet") }
            return wallet
        }
        let viewModel = BackupWalletViewModel(wallet: wallet)
        present(scene: BackupWallet.self, viewModel: viewModel, presentation: .animatedPresent) { [unowned self] userDid in
            switch userDid {
            case .backupWallet: self.presenter?.dismiss(animated: true, completion: nil)
            }
        }
    }

    func toPincode(intent: ManagePincodeCoordinator.Intent) {
        presentModalCoordinator(
            makeCoordinator: { ManagePincodeCoordinator(intent: intent, presenter: $0, useCase: useCaseProvider.makePincodeUseCase()) },
            navigationHandler: { userDid, dismissModalFlow in
                switch userDid {
                case .finish: dismissModalFlow(true)
                }
        })
    }

    func finish() {
        userIntends(to: .closeSettings)
    }

    func userIntends(to intention: Step) {
        stepper.step(intention)
    }

}
