//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-13.
//

import ComposableArchitecture
import ConfirmNewPINFeature
import InputNewPINFeature
import KeychainClient
import PINCode
import Screen
import Styleguide
import SwiftUI
import Wallet

public struct NewPINState: Equatable {
	public var wallet: Wallet
	public var step: Step
	public var inputNewPIN: InputNewPINState?
	public var confirmNewPIN: ConfirmNewPINState?
	public init(
		wallet: Wallet,
		step: Step = .step0_InputNewPIN,
		inputNewPIN: InputNewPINState? = .init(),
		confirmNewPIN: ConfirmNewPINState? = nil
	) {
		self.wallet = wallet
		self.step = step
		self.inputNewPIN = inputNewPIN
		self.confirmNewPIN = confirmNewPIN
	}
}
public extension NewPINState {
	enum Step: Equatable {
		case step0_InputNewPIN
		case step1_ConfirmNewPIN
	}
}

public enum NewPINAction: Equatable {
	case delegate(DelegateAction)
	case skip
	case savePINResult(Result<Pincode, KeychainClient.Error>)
	case inputNewPIN(InputNewPINAction)
	case confirmNewPIN(ConfirmNewPINAction)
}
public extension NewPINAction {
	enum DelegateAction: Equatable {
		case finishedSettingUpPIN(wallet: Wallet, pin: Pincode)
		case skippedPIN(wallet: Wallet)
	}
}

public struct NewPINEnvironment {
	public let keychainClient: KeychainClient
	public let mainQueue: AnySchedulerOf<DispatchQueue>
	public init(
		keychainClient: KeychainClient,
		mainQueue: AnySchedulerOf<DispatchQueue>
	) {
		self.keychainClient = keychainClient
		self.mainQueue = mainQueue
	}
}

public let newPINReducer = Reducer<
	NewPINState,
	NewPINAction,
	NewPINEnvironment
>.combine(
	
	inputNewPINReducer.optional().pullback(
		state: \.inputNewPIN,
		action: /NewPINAction.inputNewPIN,
		environment: { _ in
			InputNewPINEnvironment()
		}
	),
	
	confirmNewPINReducer.optional().pullback(
		state: \.confirmNewPIN,
		action: /NewPINAction.confirmNewPIN,
		environment: {
			ConfirmNewPINEnvironment(
				mainQueue: $0.mainQueue
			)
		}
	),
	
	Reducer { state, action, environment in
		switch action {
		case let .inputNewPIN(.delegate(.finishedSettingPIN(pin))):
			state.confirmNewPIN = .init(expectedPIN: pin)
			state.step = .step1_ConfirmNewPIN
			return .none
		case .inputNewPIN(.delegate(.skip)):
			return Effect(value: .skip)
		case .inputNewPIN(_):
			return .none
		case let .confirmNewPIN(.delegate(.finishedConfirmingPIN(pin))):
			return environment
				.keychainClient
				.savePIN(pin)
				.catchToEffect(NewPINAction.savePINResult)
		case .confirmNewPIN(_):
			return .none
		case let .savePINResult(.success(pin)):
			return Effect(value: .delegate(.finishedSettingUpPIN(wallet: state.wallet, pin: pin)))
		case let .savePINResult(.failure(error)):
			fatalError("What to do? show error? \(error)")
		case .skip:
			return Effect(value: .delegate(.skippedPIN(wallet: state.wallet)))
		case .delegate(_):
			return .none
		}
	}
)

public struct NewPINCoordinatorView: View {
	let store: Store<NewPINState, NewPINAction>
	public init(
		store: Store<NewPINState, NewPINAction>
	) {
		self.store = store
	}
}

public extension NewPINCoordinatorView {
	var body: some View {
		WithViewStore(store) { viewStore in
			Group {
				switch viewStore.step {
				case .step0_InputNewPIN:
					IfLetStore(
						store.scope(
							state: \.inputNewPIN,
							action: NewPINAction.inputNewPIN
						),
						then: InputNewPINCodeScreen.init(store:)
					)
				case .step1_ConfirmNewPIN:
					IfLetStore(
						store.scope(
							state: \.confirmNewPIN,
							action: NewPINAction.confirmNewPIN
						),
						then: ConfirmNewPINScreen.init(store:)
					)
				}
			}
		}
	}
}
