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

protocol SettingsNavigator: AnyObject {
    func toSettings()
    func toChooseWallet()
}

final class SettingsViewModel {
    private let bag = DisposeBag()
    
    private weak var navigator: SettingsNavigator?

    init(navigator: SettingsNavigator) {
        self.navigator = navigator
    }
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

        fromView.removeWalletTrigger
            .do(onNext: {
                self.navigator?.toChooseWallet()
            }).drive().disposed(by: bag)

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
