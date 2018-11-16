//
//  SettingsViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: SettingsNavigation
enum SettingsNavigation: String, TrackedUserAction {
    case userSelectedSetPincode
    case userSelectedRemovePincode
    case userSelectedBackupWallet
    case userSelectedRemoveWallet
}

// MARK: SettingsViewModel
final class SettingsViewModel: BaseViewModel<
    SettingsNavigation,
    SettingsViewModel.InputFromView,
    SettingsViewModel.Output
> {

    private let useCase: PincodeUseCase

    init(useCase: PincodeUseCase) {
        self.useCase = useCase
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {

        let isRemovePincodeButtonEnabled = input.fromController.viewWillAppear.map { [unowned self] in
            self.useCase.hasConfiguredPincode
        }
        
        let isSetPincodeButtonEnabled = isRemovePincodeButtonEnabled.map { !$0 }

        let fromView = input.fromView
        bag <~ [
            fromView.setPincodeTrigger
                .do(onNext: { [unowned stepper] in
                    stepper.step(.userSelectedSetPincode)
                }).drive(),

            fromView.removePincodeTrigger
                .do(onNext: { [unowned stepper] in
                    stepper.step(.userSelectedRemovePincode)
                }).drive(),

            fromView.backupWalletTrigger
                .do(onNext: { [unowned stepper] in
                    stepper.step(.userSelectedBackupWallet)
                }).drive(),

            fromView.removeWalletTrigger
                .do(onNext: { [unowned stepper] in
                    stepper.step(.userSelectedRemoveWallet)
                }).drive()
        ]

        let appVersion = Driver<String?>.just(appVersionString).filterNil()

        return Output(
            isSetPincodeButtonEnabled: isSetPincodeButtonEnabled,
            isRemovePincodeButtonEnabled: isRemovePincodeButtonEnabled,
            appVersion: appVersion
        )
    }
}

extension SettingsViewModel {
    struct InputFromView {
        let setPincodeTrigger: Driver<Void>
        let removePincodeTrigger: Driver<Void>
        let backupWalletTrigger: Driver<Void>
        let removeWalletTrigger: Driver<Void>
    }

    struct Output {
        let isSetPincodeButtonEnabled: Driver<Bool>
        let isRemovePincodeButtonEnabled: Driver<Bool>
        let appVersion: Driver<String>
    }
}

private extension SettingsViewModel {
    var appVersionString: String? {
        let bundle = Bundle.main
        guard
            let version = bundle.version,
            let build = bundle.build
            else { return nil }
        return "\(version) (\(build))"
    }
}
