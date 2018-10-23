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

final class SettingsViewModel {
    private let bag = DisposeBag()
    
    private weak var navigator: SettingsNavigator?

    init(navigator: SettingsNavigator) {
        self.navigator = navigator
    }
}

extension SettingsViewModel: ViewModelType {

    struct Input {
        let removeWalletTrigger: Driver<Void>
    }

    struct Output {
        let appVersion: Driver<String>
    }

    func transform(input: Input) -> Output {

        input.removeWalletTrigger
            .do(onNext: {
                self.navigator?.toChooseWallet()
            }).drive().disposed(by: bag)

        let appVersionString: String? = {
            guard
                let info = Bundle.main.infoDictionary,
                let version = info["CFBundleShortVersionString"] as? String,
                let build = info["CFBundleVersion"] as? String
                else { return nil }
            return "\(version) (\(build))"
        }()
        let appVersion = Driver<String?>.just(appVersionString).filterNil()

        return Output(
            appVersion: appVersion
        )
    }
}
