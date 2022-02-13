//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-02-11.
//

import Foundation

extension RawRepresentable where RawValue == String {
    public typealias ID = RawValue
    public var id: ID { rawValue }
}

//public final class SecurePersistence {
//    private let keychainManager: KeychainManager<Key>
//    public init(keychainManager: KeychainManager<Key> = .init()) {
//        self.keychainManager = keychainManager
//    }
//}
//
//
//public extension SecurePersistence {
//    enum Key: String, Hashable, Identifiable {
//        case keystore
//    }
//}
//
//public extension SecurePersistence {
//
//    func save(wallet: Wallet) throws {
//        try keychainManager.saveCodable(wallet, for: .keystore)
//    }
//
//    func loadWallet() throws -> Wallet? {
//        try keychainManager.loadCodable(for: .keystore)
//    }
//
//    func deleteWallet() throws {
//        try keychainManager.deleteValue(for: .keystore)
//    }
//
//}
