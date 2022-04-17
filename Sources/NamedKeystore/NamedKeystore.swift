//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-15.
//

import Foundation
import struct Zesame.Keystore

public struct NamedKeystore: Codable, Hashable {
	public let keystore: Keystore
	public let origin: KeystoreOrigin
	public let name: String?
	
	public init(
		keystore: Keystore,
		origin: KeystoreOrigin,
		name: String?
	) {
		self.keystore = keystore
		self.origin = origin
		self.name = name
	}
}
