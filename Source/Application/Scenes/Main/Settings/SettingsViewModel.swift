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
    enum Step {
        case removeWallet
    }

    override func transform(input: Input) -> Output {

        let fromView = input.fromView
        bag <~ [
            fromView.removeWalletTrigger
                .do(onNext: { [weak s=stepper] in
                    s?.step(.removeWallet)
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
    }

    struct Output {
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

extension Bundle {
    var version: String? {
        return value(of: "CFBundleShortVersionString")
    }

    var build: String? {
        return value(of: "CFBundleVersion")
    }

    func value(of key: String) -> String? {
        guard
            let info = infoDictionary,
            let value = info[key] as? String
            else { return nil }
        return value
    }
}
