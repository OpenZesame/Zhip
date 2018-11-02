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

final class SettingsViewModel: AbstractViewModel<
    SettingsViewModel.Step,
    SettingsViewModel.InputFromView,
    SettingsViewModel.Output
> {
    enum Step: String, TrackedUserAction {
        case userSelectedRemoveWallet
        case userSelectedBackupWallet
    }

    override func transform(input: Input) -> Output {

        let fromView = input.fromView
        bag <~ [
            fromView.removeWalletTrigger
                .do(onNext: { [unowned stepper] in
                    stepper.step(.userSelectedRemoveWallet)
                }).drive(),

            fromView.backupWalletTrigger
                .do(onNext: { [unowned stepper] in
                    stepper.step(.userSelectedBackupWallet)
                }).drive()
        ]

        let appVersion = Driver<String?>.just(appVersionString).filterNil()

        return Output(
            appVersion: appVersion
        )
    }
}

extension SettingsViewModel {
    struct InputFromView {
        let removeWalletTrigger: Driver<Void>
        let backupWalletTrigger: Driver<Void>
    }

    struct Output {
        let appVersion: Driver<String>
    }
}

private extension SettingsViewModel {
    var appVersionString: String? {
        let bundle = Bundle.main
        guard let version = bundle.version, let build = bundle.build else { return nil }
        return "\(version) (\(build))"
    }
}
