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
import PIN
import Screen
import Styleguide
import SwiftUI
import Wallet

public enum NewPIN {}

public extension NewPIN {
	struct State: Equatable {
		public var wallet: Wallet
		public var step: Step
		public var inputNewPIN: InputNewPIN.State?
		public var confirmNewPIN: ConfirmNewPIN.State?
		public init(
			wallet: Wallet,
			step: Step = .step0_InputNewPIN,
			inputNewPIN: InputNewPIN.State? = .init(),
			confirmNewPIN: ConfirmNewPIN.State? = nil
		) {
			self.wallet = wallet
			self.step = step
			self.inputNewPIN = inputNewPIN
			self.confirmNewPIN = confirmNewPIN
		}
	}
}
public extension NewPIN {
	enum Step: Equatable {
		case step0_InputNewPIN
		case step1_ConfirmNewPIN
	}
}

public extension NewPIN {
	enum Action: Equatable {
		case delegate(Delegate)
		case skip
		case savePINResult(Result<PIN, KeychainClient.Error>)
		case inputNewPIN(InputNewPIN.Action)
		case confirmNewPIN(ConfirmNewPIN.Action)
	}
}
public extension NewPIN.Action {
	enum Delegate: Equatable {
		case finishedSettingUpPIN(wallet: Wallet, pin: PIN)
		case skippedPIN(wallet: Wallet)
	}
}

public extension NewPIN {
	struct Environment {
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
}

public extension NewPIN {
	static let reducer = Reducer<State, Action, Environment>.combine(
		
		InputNewPIN.reducer.optional().pullback(
			state: \.inputNewPIN,
			action: /NewPIN.Action.inputNewPIN,
			environment: { _ in
				InputNewPIN.Environment()
			}
		),
		
		ConfirmNewPIN.reducer.optional().pullback(
			state: \.confirmNewPIN,
			action: /NewPIN.Action.confirmNewPIN,
			environment: {
				ConfirmNewPIN.Environment(
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
					.catchToEffect(NewPIN.Action.savePINResult)
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
}

public extension NewPIN {
	struct CoordinatorScreen: View {
		let store: Store<State, Action>
		public init(
			store: Store<State, Action>
		) {
			self.store = store
		}
	}
}

public extension NewPIN.CoordinatorScreen {
	var body: some View {
		WithViewStore(store) { viewStore in
			Group {
				switch viewStore.step {
				case .step0_InputNewPIN:
					IfLetStore(
						store.scope(
							state: \.inputNewPIN,
							action: NewPIN.Action.inputNewPIN
						),
						then: InputNewPIN.Screen.init(store:)
					)
				case .step1_ConfirmNewPIN:
					IfLetStore(
						store.scope(
							state: \.confirmNewPIN,
							action: NewPIN.Action.confirmNewPIN
						),
						then: ConfirmNewPIN.Screen.init(store:)
					)
				}
			}
		}
	}
}
