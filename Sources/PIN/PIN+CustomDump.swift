//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-11.
//

import Foundation
import CustomDump

extension PIN: CustomDumpStringConvertible {
	public var customDumpDescription: String {
		debugDescription
	}
}
