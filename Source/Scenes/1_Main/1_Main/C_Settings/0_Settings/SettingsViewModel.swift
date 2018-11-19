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
import RxDataSources

// MARK: SettingsNavigation
enum SettingsNavigation: TrackedUserAction {
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

    // Section 3
    case backupWallet
    case removeWallet

    // Section 4
    case openAppStore
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

    override func transform(input: Input) -> Output {
        func userWantsToNavigate(to intention: Step) {
            stepper.step(intention)
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
            sections: sections
        )
    }
}

extension SettingsViewModel {
    struct InputFromView {
        let selectedIndedPath: Driver<IndexPath>
    }

    struct Output {
        let sections: Driver<[SectionModel<Void, SettingsItem>]>
    }
}

private extension SettingsViewModel {

    // swiftlint:disable:next function_body_length
    func makeItemMatrix() -> [[SettingsItem]] {
        var sections = [[SettingsItem]]()
        let hasPin = useCase.hasConfiguredPincode

        sections += [
            SettingsItem.whenSelectedNavigate(
                to: hasPin ? .removePincode : .setPincode,
                titled: hasPin ? €.removePincode : €.setPincode
            )
        ]

        sections += [
            SettingsItem.whenSelectedNavigate(to: .starUsOnGithub, titled: €.starUsOnGithub),
            SettingsItem.whenSelectedNavigate(to: .reportIssueOnGithub, titled: €.reportIssueOnGithub),
            SettingsItem.whenSelectedNavigate(to: .acknowledgments, titled: €.acknowledgements)
        ]

        sections += [
            SettingsItem.whenSelectedNavigate(to: .readTermsOfService, titled: €.termsOfService),
            SettingsItem.whenSelectedNavigate(to: .readERC20Warning, titled: €.readERC20Warning)
        ]

        sections += [
            SettingsItem.whenSelectedNavigate(to: .backupWallet, titled: €.backupWallet),
            SettingsItem.whenSelectedNavigate(to: .removeWallet, titled: €.removeWallet, style: .destructive)
        ]

        sections += [
            SettingsItem.whenSelectedNavigate(to: .openAppStore, titled: appVersionString)
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
            let build = bundle.build
            else { incorrectImplementation("Should be able to read version and build number") }
        return "\(version) (\(build))"
    }
}
