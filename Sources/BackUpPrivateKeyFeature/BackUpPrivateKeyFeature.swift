//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import ComposableArchitecture

public struct BackUpPrivateKeyState: Equatable {
	public init() {
		
	}
}

public enum BackUpPrivateKeyAction: Equatable {
	
}

public struct BackUpPrivateKeyEnvironment {
	public init() {}
}

public let backUpPrivateKeyReducer = Reducer<BackUpPrivateKeyState, BackUpPrivateKeyAction, BackUpPrivateKeyEnvironment> { state, action, environment in
	return .none
}
