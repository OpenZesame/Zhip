//
//  SettingsViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

// MARK: SettingsNavigation
enum SettingsNavigation: String, TrackedUserAction {
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
            // TOOO change icon when asset available
            .whenSelectedNavigate(to: .changeAnalyticsPermissions, titled: €.changeAnalyticsPermissions, icon: Icon.document)
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
        return "\(appName) v\(version) (\(build))"
    }
}
