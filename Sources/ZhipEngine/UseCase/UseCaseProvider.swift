//
//  UseCaseProvider.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import Foundation
import Zesame
import Preferences
import SecurePersistence

public protocol ContactsUseCase {
    func toggleContact(address: Address)
    func isContact(address: Address) -> Bool
}

public final class DefaultContactsUseCase {
    private var contacts = Set<Contact>()
    init() {}
}

public extension DefaultContactsUseCase {
    func toggleContact(address: Address) {
        if let contactIndex = contacts.firstIndex(where: { $0.address == address }) {
            contacts.remove(at: contactIndex)
        } else {
            contacts.insert(.init(address: address))
        }
    }
    
    func isContact(address: Address) -> Bool {
        contacts.contains(where: { $0.address == address })
    }
}

public protocol UseCaseProvider {
    func makeOnboardingUseCase() -> OnboardingUseCase
    func makeWalletUseCase() -> WalletUseCase
    func makePINCodeUseCase() -> PINCodeUseCase
    func makeBalancesUseCase() -> BalancesUseCase
    var hasWalletConfigured: Bool { get }
    var hasConfiguredPincode: Bool { get }
    func nuke(resetHasAppRunBeforeFlag: Bool, resetHasAcceptedTermsOfService: Bool)
}
public extension UseCaseProvider {
    func nuke() {
        nuke(resetHasAppRunBeforeFlag: false, resetHasAcceptedTermsOfService: false)
    }
}

public final class DefaultUseCaseProvider: UseCaseProvider {
   
    private let preferences: Preferences
    private let securePersistence: SecurePersistence
    private let zilliqaService: ZilliqaService
    
    // TODO: Clean up, for now this works. Some of the usecases hold Publishers
    // that must be shared. Thus we hold a reference to the same instance of
    // each use case (singleton). This can at least be lifted up to the level of
    // `Preferences` and `SecurePersistence`...
    private lazy var onboardingUseCase: OnboardingUseCase = DefaultOnboardingUseCase(
        preferences: preferences,
        securePersistence: securePersistence
    )
    
    private lazy var walletUseCase: WalletUseCase = DefaultWalletUseCase(
        preferences: preferences,
        securePersistence: securePersistence,
        zilliqaService: zilliqaService
    )
    
    private lazy var pinCodeUseCase: PINCodeUseCase = DefaultPINCodeUseCase(
        preferences: preferences,
        securePersistence: securePersistence
    )
    
    private lazy var balancesUseCase: BalancesUseCase = DefaultBalancesUseCase(
        zilliqaService: zilliqaService,
        securePersistence: securePersistence,
        preferences: preferences
    )
    
    public var hasWalletConfigured: Bool { walletUseCase.hasConfiguredWallet }
    public var hasConfiguredPincode: Bool { pinCodeUseCase.hasConfiguredPincode }
  
    public func nuke(
        resetHasAppRunBeforeFlag: Bool = false,
        resetHasAcceptedTermsOfService: Bool = false
    ) {
        try! securePersistence.deleteAll()
        var excludedFlags: [PreferencesKey] = []
        if !resetHasAppRunBeforeFlag {
            excludedFlags.append(.hasRunAppBefore)
        }
        if !resetHasAcceptedTermsOfService {
            excludedFlags.append(.hasAcceptedTermsOfService)
        }
        try! preferences.deleteAll(but: excludedFlags)
        
        walletUseCase.deleteWallet() // Technical debt: sync `Subject`s
        pinCodeUseCase.deletePincode() // Technical debt: sync `Subject`s
    }
    
    public init(
        preferences: Preferences = .default,
        securePersistence: SecurePersistence = .default,
        zilliqaService: ZilliqaService = DefaultZilliqaService.default
    ) {
        self.preferences = preferences
        self.securePersistence = securePersistence
        self.zilliqaService = zilliqaService
    }
}

public extension DefaultUseCaseProvider {
    static let shared: UseCaseProvider = DefaultUseCaseProvider()
}

public extension DefaultUseCaseProvider {
    func makeOnboardingUseCase() -> OnboardingUseCase {
        onboardingUseCase
    }
    
    func makeWalletUseCase() -> WalletUseCase {
        walletUseCase
    }
    
    func makePINCodeUseCase() -> PINCodeUseCase {
        pinCodeUseCase
    }
    
    func makeBalancesUseCase() -> BalancesUseCase {
        balancesUseCase
    }
}
