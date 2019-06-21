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

import Foundation

import Zesame

import RxSwift
import RxCocoa
import RxDataSources

typealias SettingsItem = NavigatingCellModel<SettingsViewModel.NavigationStep>

// MARK: SettingsNavigation
enum SettingsNavigation {
    // Navigation Bar
    case closeSettings

    // Section 0
    case removePincode, setPincode

    // Section 1
    case starUsOnGithub
    case reportIssueOnGithub
    case acknowledgments

    // Section 2
    case readTermsOfService
    case readERC20Warning
    case readCustomECCWarning
    case changeAnalyticsPermissions

    // Section 3
    case backupWallet
    case removeWallet
}

private typealias € = L10n.Scene.Settings.Cell

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
        func userWantsToNavigate(to intention: NavigationStep) {
            navigator.next(intention)
        }

        let sections = input.fromController.viewWillAppear
            .map { [unowned self] _ in return self.makeSections() }

        let selectedCell: Driver<SettingsItem> = input.fromView.selectedIndedPath.withLatestFrom(sections) {
            $1[$0.section].items[$0.row]
        }

        bag <~ [
            input.fromController.rightBarButtonTrigger
                .do(onNext: { userWantsToNavigate(to: .closeSettings) })
                .drive(),

            selectedCell.do(onNext: {
                userWantsToNavigate(to: $0.destination)
            }).drive()
        ]

        return Output(
            sections: sections,
            footerText: .just(appVersionString)
        )
    }
}

extension SettingsViewModel {
    struct InputFromView {
        let selectedIndedPath: Driver<IndexPath>
    }

    struct Output {
        let sections: Driver<[SectionModel<Void, SettingsItem>]>
        let footerText: Driver<String>
    }
}

private extension SettingsViewModel {

    // swiftlint:disable:next function_body_length
    func makeItemMatrix() -> [[SettingsItem]] {
        let Icon = Asset.Icons.Small.self
        var sections = [[SettingsItem]]()
        let hasPin = useCase.hasConfiguredPincode

        sections += [
            .whenSelectedNavigate(
                to: hasPin ? .removePincode : .setPincode,
                titled: hasPin ? €.removePincode : €.setPincode,
                icon: hasPin ? Icon.delete : Icon.pinCode,
                style: hasPin ? .destructive : .normal
            )
        ]

        sections += [
            .whenSelectedNavigate(to: .starUsOnGithub, titled: €.starUsOnGithub, icon: Icon.githubStar),
            .whenSelectedNavigate(to: .reportIssueOnGithub, titled: €.reportIssueOnGithub, icon: Icon.githubIssue),
            .whenSelectedNavigate(to: .acknowledgments, titled: €.acknowledgements, icon: Icon.cup)
        ]

        sections += [
            .whenSelectedNavigate(to: .readTermsOfService, titled: €.termsOfService, icon: Icon.document),
            .whenSelectedNavigate(to: .readERC20Warning, titled: €.readERC20Warning, icon: Icon.warning),
            .whenSelectedNavigate(to: .changeAnalyticsPermissions, titled: €.crashReportingPermissions, icon: Icon.analytics),
            .whenSelectedNavigate(to: .readCustomECCWarning, titled: €.readCustomECCWarning, icon: Icon.ecc)
        ]

        sections += [
            .whenSelectedNavigate(to: .backupWallet, titled: €.backupWallet, icon: Icon.backUp),
            .whenSelectedNavigate(to: .removeWallet, titled: €.removeWallet, icon: Icon.delete, style: .destructive)
        ]

        return sections
    }

    func makeSections() -> [SectionModel<Void, SettingsItem>] {
        return makeItemMatrix().map { array in return SectionModel(model: (), items: array) }
    }

    var appVersionString: String {
        let bundle = Bundle.main
        guard
            let version = bundle.version,
            let build = bundle.build,
            let appName = bundle.name
            else { incorrectImplementation("Should be able to read name, version and build number") }
        
        let networkDisplayName = network.displayName
        return "\(appName) v\(version) (\(build))\n\(L10n.Scene.Settings.Footer.network(networkDisplayName))"
    }
}

private extension Network {
    var displayName: String {
        switch self {
        case .mainnet: return "mainnet"
        case .testnet: return "testnet"
        }
    }
}
