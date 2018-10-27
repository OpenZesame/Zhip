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

final class SettingsViewModel: Navigatable {
    enum Step {
        case removeWallet
    }

    let stepper = Stepper<Step>()

    private let bag = DisposeBag()
}

extension SettingsViewModel: ViewModelType {

    struct Input: InputType {
        struct FromView {
            let removeWalletTrigger: Driver<Void>
        }

        let fromView: FromView
        let fromController: ControllerInput

        init(fromView: FromView, fromController: ControllerInput) {
            self.fromView = fromView
            self.fromController = fromController
        }
    }

    struct Output {
        let appVersion: Driver<String>
    }

    func transform(input: Input) -> Output {

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
