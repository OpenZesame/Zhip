//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-11.
//

import Foundation
import CustomDump

// MARK: KeystoreOrigin
public enum KeystoreOrigin: Int, Codable, Hashable {
	case generatedByThisApp
	case importedPrivateKey
	case importedKeystore
}


extension KeystoreOrigin: CustomDumpStringConvertible {
	public var customDumpDescription: String {
		switch self {
		case .generatedByThisApp: return "generatedByThisApp"
		case .importedKeystore: return "importedKeystore"
		case .importedPrivateKey: return "importedPrivateKey"
		}
	}
}
