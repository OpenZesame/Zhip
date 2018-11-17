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
enum SettingsNavigation: TrackedUserAction {
    case setPincode
    case removePincode
    case backupWallet
    case removeWallet
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
        func userIntends(to intention: Step) {
            stepper.step(intention)
        }

        let isRemovePincodeButtonEnabled = input.fromController.viewWillAppear.map { [unowned self] in
            self.useCase.hasConfiguredPincode
        }
        
        let isSetPincodeButtonEnabled = isRemovePincodeButtonEnabled.map { !$0 }

        let fromView = input.fromView
        bag <~ [
            fromView.setPincodeTrigger
                .do(onNext: { userIntends(to: .setPincode) })
                .drive(),

            fromView.removePincodeTrigger
                .do(onNext: { userIntends(to: .removePincode) })
                .drive(),

            fromView.backupWalletTrigger
                .do(onNext: { userIntends(to: .backupWallet) })
                .drive(),

            fromView.removeWalletTrigger
                .do(onNext: { userIntends(to: .removeWallet) })
                .drive()
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
