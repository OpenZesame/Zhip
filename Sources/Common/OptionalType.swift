//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-17.
//

import Foundation

public protocol OptionalType {
	associatedtype Wrapped
	var wrapped: Wrapped? { get }
}
extension Optional: OptionalType {
	public var wrapped: Wrapped? {
		switch self {
		case let .some(wrapped): return wrapped
		case .none: return nil
		}
		
	}
}
