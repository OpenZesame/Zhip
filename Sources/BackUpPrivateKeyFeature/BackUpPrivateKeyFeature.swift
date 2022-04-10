//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import ComposableArchitecture

public enum BackUpPrivateKey {}

public extension BackUpPrivateKey {
 struct State: Equatable {
	public init() {
		
	}
 }
}

public extension BackUpPrivateKey {
 enum Action: Equatable {
	
 }
}

public extension BackUpPrivateKey {
 struct Environment {
	public init() {}
 }
}

	public extension BackUpPrivateKey {
static let reducer = Reducer<State, Action, Environment> { state, action, environment in
	return .none
}
	}
