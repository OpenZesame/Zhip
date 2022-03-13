//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import ComposableArchitecture

public struct NewPINState: Equatable {
	public init() {}
}

public enum NewPINAction: Equatable {}

public struct NewPINEnvironment {
	public init() {}
}

public let newPINReducer = Reducer<NewPINState, NewPINAction, NewPINEnvironment> { state, action, environment in
	return .none
}
