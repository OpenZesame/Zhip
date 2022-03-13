//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import ComposableArchitecture

public struct RestoreWalletState: Equatable {
	public init() {}
}

public enum RestoreWalletAction: Equatable {
	case delegate(DelegateAction)
}
public extension RestoreWalletAction {
	enum DelegateAction: Equatable {
		case finishedRestoringWallet
	}
}

public struct RestoreWalletEnvironment {
	public init() {}
}

public let restoreWalletReducer = Reducer<RestoreWalletState, RestoreWalletAction, RestoreWalletEnvironment> { state, action, environment in
	return .none
}
