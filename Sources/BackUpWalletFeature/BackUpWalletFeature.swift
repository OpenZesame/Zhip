//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import ComposableArchitecture

public struct BackUpWalletState: Equatable {
	public init() {}
}

public enum BackUpWalletAction: Equatable {
	
}

public struct BackUpWalletEnvironment {
	public init() {}
}

public let backUpWalletReducer = Reducer<BackUpWalletState, BackUpWalletAction, BackUpWalletEnvironment> { state, action, environment in
	return .none
}
