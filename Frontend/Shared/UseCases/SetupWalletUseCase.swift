//
//  SetupWalletUseCase.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import Foundation
import ZhipEngine
import Combine
import enum Zesame.KeyRestoration
import struct Zesame.Keystore
import struct Zesame.KeyPair
import enum Zesame.KeyDerivationFunction
import protocol Zesame.ZilliqaService

protocol SecurePersisting: AnyObject {
    var securePersistence: SecurePersistence { get }
}

protocol WalletUseCase {
    func createNewWallet(name: String?, encryptionPassword: String) async throws -> Wallet
    func restoreWallet(name: String?, from restoration: KeyRestoration) async throws -> Wallet
    func save(wallet: Wallet)
    func deleteWallet()

    /// Checks if the passed `password` was used to encypt the Keystore
    func verify(password: String, forKeystore keystore: Keystore) async throws -> Bool
    func extractKeyPairFrom(keystore: Keystore, encryptedBy password: String) async throws -> KeyPair
    func loadWallet() -> Wallet?
    var hasConfiguredWallet: Bool { get }
}


extension WalletUseCase where Self: SecurePersisting {

    func deleteWallet() {
        securePersistence.deleteWallet()
    }

    func loadWallet() -> Wallet? {
        return securePersistence.wallet
    }

    func save(wallet: Wallet) {
        securePersistence.save(wallet: wallet)
    }

    var hasConfiguredWallet: Bool {
        return securePersistence.hasConfiguredWallet
    }
}

extension WalletUseCase {

    /// Checks if the passed `password` was used to encypt the Keystore inside the Wallet
    func verify(password: String, forKeystore keystore: Keystore) async throws -> Bool {
        try await verify(password: password, forKeystore: keystore)
    }

    func extractKeyPairFrom(keystore: Keystore, encryptedBy password: String) async throws -> KeyPair {
        try await extractKeyPairFrom(keystore: keystore, encryptedBy: password)
    }
}


final class DefaultWalletUseCase: WalletUseCase, SecurePersisting {

    private let zilliqaService: ZilliqaService
    let securePersistence: SecurePersistence
    
    init(
        securePersistence: SecurePersistence,
        zilliqaService: ZilliqaService
    ) {
        self.securePersistence = securePersistence
        self.zilliqaService = zilliqaService
    }
}


extension DefaultWalletUseCase {

    /// Checks if the passed `password` was used to encypt the Keystore inside the Wallet
    func verify(password: String, forWallet wallet: Wallet) async throws -> Bool {
        try await zilliqaService.verifyThat(encryptionPassword: password, canDecryptKeystore: wallet.keystore)
    }

    func extractKeyPairFrom(wallet: Wallet, encryptedBy password: String) async throws -> KeyPair {
        try await zilliqaService.extractKeyPairFrom(keystore: wallet.keystore, encryptedBy: password)
    }
    
    func createNewWallet(name: String?, encryptionPassword: String) async throws -> Wallet {
        let zesameWallet = try await zilliqaService.createNewWallet(
            encryptionPassword: encryptionPassword,
            kdf: KeyDerivationFunction.default
        )
        return Wallet(name: name, wallet: zesameWallet, origin: .generatedByThisApp)
    }
    
    func restoreWallet(name: String?, from restoration: KeyRestoration) async throws -> Wallet {
        let origin: Wallet.Origin
        switch restoration {
        case .keystore: origin = .importedKeystore
        case .privateKey: origin = .importedPrivateKey
        }
        let restored = try await zilliqaService.restoreWallet(from: restoration)
        return Wallet(name: name, wallet: restored, origin: origin)
    }
}
