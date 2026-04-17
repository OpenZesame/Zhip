//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
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

import Combine
import Foundation
import UIKit
import Zesame

typealias SettingsItem = NavigatingCellModel<SettingsViewModel.NavigationStep>

// MARK: SettingsNavigation

enum SettingsNavigation {
    /// Navigation Bar
    case closeSettings

    /// Section 0
    case removePincode, setPincode

    // Section 1
    case starUsOnGithub
    case reportIssueOnGithub
    case acknowledgments

    // Section 2
    case readTermsOfService
    case readCustomECCWarning
    case changeAnalyticsPermissions

    // Section 3
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

    override func transform(input: Input) -> Output {
        func userWantsToNavigate(to intention: NavigationStep) {
            navigator.next(intention)
        }

        let sections: AnyPublisher<[SectionModel<Void, SettingsItem>], Never> = input.fromController.viewWillAppear
            .map { [unowned self] _ in return makeSections() }
            .eraseToAnyPublisher()

        let selectedCell: AnyPublisher<SettingsItem, Never> = input.fromView.selectedIndexPath.withLatestFrom(sections) {
            $1[$0.section].items[$0.row]
        }

        bag <~ [
            input.fromController.rightBarButtonTrigger
                .do(onNext: { userWantsToNavigate(to: .closeSettings) })
                .drive(),

            selectedCell.do(onNext: {
                userWantsToNavigate(to: $0.destination)
            }).drive(),
        ]

        return Output(
            sections: sections,
            footerText: .just(appVersionString)
        )
    }
}

extension SettingsViewModel {
    struct InputFromView {
        let selectedIndexPath: AnyPublisher<IndexPath, Never>
    }

    struct Output {
        let sections: AnyPublisher<[SectionModel<Void, SettingsItem>], Never>
        let footerText: AnyPublisher<String, Never>
    }
}

private extension SettingsViewModel {
    func makeItemMatrix() -> [[SettingsItem]] {
        var sections = [[SettingsItem]]()
        let hasPin = useCase.hasConfiguredPincode

        sections += [
            .whenSelectedNavigate(
                to: hasPin ? .removePincode : .setPincode,
                titled: hasPin ? String(localized: .Settings.removePincode) : String(localized: .Settings.setPincode),
                icon: hasPin ? UIImage(resource: .delete) : UIImage(resource: .pinCode),
                style: hasPin ? .destructive : .normal
            ),
        ]

        sections += [
            .whenSelectedNavigate(
                to: .starUsOnGithub,
                titled: String(localized: .Settings.starUsOnGithub),
                icon: UIImage(resource: .githubStar)
            ),
            .whenSelectedNavigate(
                to: .reportIssueOnGithub,
                titled: String(localized: .Settings.reportIssueOnGithub),
                icon: UIImage(resource: .githubIssue)
            ),
            .whenSelectedNavigate(
                to: .acknowledgments,
                titled: String(localized: .Settings.acknowledgements),
                icon: UIImage(resource: .cup)
            ),
        ]

        sections += [
            .whenSelectedNavigate(
                to: .readTermsOfService,
                titled: String(localized: .Settings.termsOfService),
                icon: UIImage(resource: .document)
            ),
            .whenSelectedNavigate(
                to: .changeAnalyticsPermissions,
                titled: String(localized: .Settings.crashReportingPermissions),
                icon: UIImage(resource: .analyticsSmall)
            ),
            .whenSelectedNavigate(
                to: .readCustomECCWarning,
                titled: String(localized: .Settings.readCustomECCWarning),
                icon: UIImage(resource: .ECC)
            ),
        ]

        sections += [
            .whenSelectedNavigate(
                to: .backupWallet,
                titled: String(localized: .Settings.backupWallet),
                icon: UIImage(resource: .backUp)
            ),
            .whenSelectedNavigate(
                to: .removeWallet,
                titled: String(localized: .Settings.removeWallet),
                icon: UIImage(resource: .delete),
                style: .destructive
            ),
        ]

        return sections
    }

    func makeSections() -> [SectionModel<Void, SettingsItem>] {
        makeItemMatrix().map { array in SectionModel(model: (), items: array) }
    }

    var appVersionString: String {
        let bundle = Bundle.main
        guard
            let version = bundle.version,
            let build = bundle.build,
            let appName = bundle.name
        else { incorrectImplementation("Should be able to read name, version and build number") }

        let networkDisplayName = network.displayName
        return "\(appName) v\(version) (\(build))\n\(String(localized: .Settings.networkFooter(network: networkDisplayName)))"
    }
}

private extension Network {
    var displayName: String {
        switch self {
        case .mainnet: "mainnet"
        case .testnet: "testnet"
        }
    }
}
