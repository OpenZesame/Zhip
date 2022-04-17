//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-15.
//

import Foundation

public struct Password: Equatable {
	public let password: String
	public init(_ password: String) {
		self.password = password
	}
}
