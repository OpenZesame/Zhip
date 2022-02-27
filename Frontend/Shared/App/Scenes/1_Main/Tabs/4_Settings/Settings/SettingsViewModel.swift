//
//  SettingsViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import Foundation
import ZhipEngine
import Combine

// MARK: - SettingsNavigationStep
// MARK: -
public enum SettingsNavigationStep: Int, Hashable {
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
    case readCustomECCWarning
    case changeAnalyticsPermissions
    
    // Section 3
    case backupWallet
    case removeWallet
}


// MARK: - SettingsViewModel
// MARK: -
public final class SettingsViewModel: ObservableObject {
    
    @Published var isAskingForDeleteWalletConfirmation: Bool = false
    
    private unowned let navigator: Navigator
    private let walletUseCase: WalletUseCase
    private let pincodeUseCase: PINCodeUseCase
    @Published var isPINSet: Bool
    
    private var cancellables = Set<AnyCancellable>()

    public init(
        navigator: Navigator,
        walletUseCase: WalletUseCase,
        pincodeUseCase: PINCodeUseCase
    ) {
        self.navigator = navigator
        self.walletUseCase = walletUseCase
        self.pincodeUseCase = pincodeUseCase
        self.isPINSet = pincodeUseCase.hasConfiguredPincode
        
        subscribeToPublishers()
    }
}

import SwiftUI
public struct SettingsChoice: Identifiable {
    public typealias ID = SettingsNavigationStep
    public var id: ID { navigationStep }

    let navigationStep: SettingsNavigationStep
    let title: String
    let icon: Image
    let isDestructive: Bool
    
    init(
        _ navigationStep: SettingsNavigationStep,
        title: String,
        icon: Image,
        isDestructive: Bool = false
    ) {
        self.navigationStep = navigationStep
        self.title = title
        self.icon = icon
        self.isDestructive = isDestructive
    }
    
    init(
        _ navigationStep: SettingsNavigationStep,
        title: String,
        icon: String,
        isDestructive: Bool = false
    ) {
        self.init(navigationStep, title: title, icon: Image(icon), isDestructive: isDestructive)
    }
    
    init(
        _ navigationStep: SettingsNavigationStep,
        title: String,
        iconSmall: String,
        isDestructive: Bool = false
    ) {
        self.init(
            navigationStep,
            title: title,
            icon: "Icons/Small/\(iconSmall)",
            isDestructive: isDestructive
        )
    }
}

public struct SettingsChoiceSection: Identifiable {
    public typealias ID = Array<Array<SettingsChoice>>.Index
    public var id: ID { index }
    let index: ID
    let choices: [SettingsChoice]
}

// MARK: - Public
// MARK: -
public extension SettingsViewModel {
    
    func userSelected(_ settingsChoice: SettingsChoice) {
        if settingsChoice.navigationStep == .removeWallet {
            isAskingForDeleteWalletConfirmation = true
        } else {
            navigator.step(settingsChoice.navigationStep)
        }
    }
    
    typealias Navigator = NavigationStepper<SettingsNavigationStep>
    
    var settingsChoicesSections: [SettingsChoiceSection] {
        
        let removePINChoice = SettingsChoice(
            .removePincode,
            title: "Remove pincode",
            iconSmall: "Delete",
            isDestructive: true
        )
        let setPINChoice = SettingsChoice(
            .setPincode,
            title: "Set pincode",
            iconSmall: "PinCode"
        )
        
        
        let choiceMatrix: [[SettingsChoice]] = [
            [
                isPINSet ? removePINChoice : setPINChoice
            ],
            [
                .init(
                    .starUsOnGithub,
                    title: "Star us on Github (login required)",
                    iconSmall: "GithubStar"
                ),
                .init(
                    .reportIssueOnGithub,
                    title: "Report issue (Github login required)",
                    iconSmall: "GithubIssue"
                ),
                .init(
                    .acknowledgments,
                    title: "Acknowledgments",
                    iconSmall: "Cup"
                ),
                .init(
                    .readTermsOfService,
                    title: "Terms of service",
                    iconSmall: "Document"
                )
            ],
            [
                .init(
                    .backupWallet,
                    title: "Backup wallet",
                    iconSmall: "BackUp"
                ),
                .init(
                    .removeWallet,
                    title: "Remove wallet",
                    iconSmall: "Delete",
                    isDestructive: true
                )
            ]
        ]
        
        return choiceMatrix.enumerated().map {
            .init(index: $0.offset, choices: $0.element)
        }
    }
        
    func confirmWalletDeletion() {
        defer {
            isAskingForDeleteWalletConfirmation = false
        }
        navigator.step(.removeWallet)
    }
}

private extension SettingsViewModel {
    func subscribeToPublishers() {
        pincodeUseCase.pincodeSubject
            .map { $0 != nil }
            .receive(on: RunLoop.main)
            .assign(to: \.isPINSet, on: self)
            .store(in: &cancellables)
    }
}
