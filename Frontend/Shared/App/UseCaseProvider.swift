//
//  UseCaseProvider.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import Foundation
import Zesame
import ZhipEngine

protocol ContactsUseCase {
    func toggleContact(address: Address)
    func isContact(address: Address) -> Bool
}
final class DefaultContactsUseCase {
    private var contacts = Set<Contact>()
    init() {}
}

extension DefaultContactsUseCase {
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

protocol UseCaseProvider {
    func makeOnboardingUseCase() -> OnboardingUseCase
    func makeWalletUseCase() -> WalletUseCase
    func makePINCodeUseCase() -> PINCodeUseCase
    
}

final class DefaultUseCaseProvider: UseCaseProvider {
   
    private let preferences: Preferences
    private let securePersistence: SecurePersistence
    private let zilliqaService: ZilliqaService
    
    init(
        preferences: Preferences = .default,
        securePersistence: SecurePersistence = .default,
        zilliqaService: ZilliqaService = DefaultZilliqaService.default
    ) {
        self.preferences = preferences
        self.securePersistence = securePersistence
        self.zilliqaService = zilliqaService
    }
}

extension DefaultUseCaseProvider {
    static let shared: UseCaseProvider = DefaultUseCaseProvider()
}

extension DefaultUseCaseProvider {
    func makeOnboardingUseCase() -> OnboardingUseCase {
        DefaultOnboardingUseCase(
            preferences: preferences,
            securePersistence: securePersistence
        )
    }
    
    func makeWalletUseCase() -> WalletUseCase {
        DefaultWalletUseCase(
            securePersistence: securePersistence,
            zilliqaService: zilliqaService
        )
    }
    
    func makePINCodeUseCase() -> PINCodeUseCase {
        DefaultPINCodeUseCase(
            preferences: preferences,
            securePersistence: securePersistence
        )
    }
}
