//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-02-11.
//

import Common
import CustomDump
import Foundation
import Zesame
import ZilliqaAPIEndpoint

public struct Wallet: Codable, Equatable {
    public let name: String?
    public let wallet: Zesame.Wallet
    public let origin: Origin

    public init(name: String?, wallet: Zesame.Wallet, origin: Origin) {
        self.name = name
        self.wallet = wallet
        self.origin = origin
    }
}

public extension Wallet {
    // MARK: Origin
    enum Origin: Int, Codable, Equatable {
        case generatedByThisApp
        case importedPrivateKey
        case importedKeystore
    }

    enum Error: Swift.Error {
        case isNil
    }
}

public extension Wallet {
    var keystore: Keystore {
        wallet.keystore
    }

    var bech32Address: Bech32Address {
        do {
            return try Bech32Address(ethStyleAddress: wallet.address, network: network)
        } catch { incorrectImplementation("should work") }
    }
    
    var legacyAddress: LegacyAddress {
        wallet.address
    }
}


#if DEBUG
public extension KDFParams {
	
	static var unsafeFast: Self {
		do {
			return try Self(
				costParameterN: 1,
				costParameterC: 1
			)
		} catch {
			fatalError("Incorrect implementation, should always be able to create default KDF params, unexpected error: \(error)")
		}
	}
}
#endif

extension Wallet: CustomDumpStringConvertible {
	public var customDumpDescription: String {
"""
Wallet(
 address: \(try! Bech32Address.init(ethStyleAddress: self.wallet.address).asString)
 origin: \(self.origin)
 legacyAddress: \(self.wallet.address.asString))
)
"""
	}
}

extension Wallet.Origin: CustomDumpStringConvertible {
	public var customDumpDescription: String {
		switch self {
		case .generatedByThisApp: return "generatedByThisApp"
		case .importedKeystore: return "importedKeystore"
		case .importedPrivateKey: return "importedPrivateKey"
		}
	}
}
