//
//  GenerateNewWalletScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-14.
//

import Checkbox
import Common
import ComposableArchitecture
import HoverPromptTextField
import InputField
import KeychainClient
import Password
import PasswordValidator
import PasswordInputFields
import Screen
import Styleguide
import SwiftUI
import Wallet
import WalletGenerator

public enum GenerateNewWallet {}

public extension GenerateNewWallet {
	
	struct State: Equatable {
		@BindableState public var password: String
		@BindableState public var passwordConfirmation: String
		@BindableState public var userHasConfirmedBackingUpPassword: Bool
		
		public var isContinueButtonEnabled: Bool
		public var isGeneratingWallet: Bool
		
		public var alert: AlertState<Action>?
		
		public init(
			password: String = "",
			passwordConfirmation: String = "",
			userHasConfirmedBackingUpPassword: Bool = false,
			isContinueButtonEnabled: Bool = false,
			isGeneratingWallet: Bool = false,
			alert: AlertState<Action>? = nil
		) {
			self.password = password
			self.passwordConfirmation = passwordConfirmation
			self.userHasConfirmedBackingUpPassword = userHasConfirmedBackingUpPassword
			self.isContinueButtonEnabled = isContinueButtonEnabled
			self.isGeneratingWallet = isGeneratingWallet
			self.alert = alert
		}
	}
}

public extension GenerateNewWallet {
	enum Action: Equatable, BindableAction {
		case alertDismissed
		case onAppear
		case continueButtonTapped
		
		case binding(BindingAction<State>)
		case delegate(Delegate)
		
		case walletGenerationResult(Result<Wallet, WalletGeneratorError>)
	}
}

public extension GenerateNewWallet.Action {
	enum Delegate: Equatable {
		case finished(Wallet)
	}
}

public extension GenerateNewWallet {
	struct Environment {
		
		public let backgroundQueue: AnySchedulerOf<DispatchQueue>
		public let mainQueue: AnySchedulerOf<DispatchQueue>
		public let passwordValidator: PasswordValidator
		public let walletGenerator: WalletGenerator
		
		public init(
			backgroundQueue: AnySchedulerOf<DispatchQueue>,
			mainQueue: AnySchedulerOf<DispatchQueue>,
			passwordValidator: PasswordValidator,
			walletGenerator: WalletGenerator
		) {
			self.backgroundQueue = backgroundQueue
			self.mainQueue = mainQueue
			self.passwordValidator = passwordValidator
			self.walletGenerator = walletGenerator
		}
	}
}

public extension GenerateNewWallet {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		
		switch action {
		case .alertDismissed:
			state.alert = nil
			return .none
		case .onAppear:
#if DEBUG
			state.password = unsafeDebugPassword
			state.passwordConfirmation = unsafeDebugPassword
			state.userHasConfirmedBackingUpPassword = true
#endif
			return .none
			
		case .binding:
			state.isContinueButtonEnabled = environment.passwordValidator
				.validatePasswords(
					.init(
						password: state.password,
						confirmPassword: state.passwordConfirmation
					)
				) != nil && state.userHasConfirmedBackingUpPassword
			
			return .none
			
			
		case .continueButtonTapped:
			state.isGeneratingWallet = true
			let password = Password(state.password)
			
			return environment.walletGenerator
				.generate(password: password, name: nil)
				.subscribe(on: environment.backgroundQueue)
				.receive(on: environment.mainQueue)
				.catchToEffect(Action.walletGenerationResult)
			
		case .walletGenerationResult(.success(let wallet)):
			state.isGeneratingWallet = false
			return Effect(value: .delegate(.finished(wallet)))
			
		case .walletGenerationResult(.failure(let walletGenerationError)):
			state.isGeneratingWallet = false
			state.alert = .init(title: TextState("Failed to generate wallet, reason: \(String(describing: walletGenerationError))"))
			return .none
			
		default:
			return .none
		}
	}.binding()
}

// MARK: - GenerateNewWalletScreen
// MARK: -

public extension GenerateNewWallet {
	struct Screen: View {
		let store: Store<State, Action>
		public init(store: Store<State, Action>) {
			self.store = store
		}
	}
}

// MARK: - View
// MARK: -

public extension GenerateNewWallet.Screen {
	
	var body: some View {
		WithViewStore(store) { viewStore in
			ForceFullScreen {
				VStack(spacing: 40) {
					
					Labels(
						title: "Set an encryption password",
						subtitle: "Your encryption password is used to encrypt your private key. Make sure to back up your encryption password before proceeding.\n\nUse a secure and unique password. It must be at least \(minimumEncryptionPasswordLength) characters long."
					)
					
					VStack {
						VStack(alignment: .leading, spacing: 2) {
							Text("Password").foregroundColor(.white)
							SecureField("Password", text: viewStore.binding(\.$password))
						}
						
						VStack(alignment: .leading, spacing: 2) {
							Text("Confirm password").foregroundColor(.white)
							SecureField("Confirm password", text: viewStore.binding(\.$passwordConfirmation))
						}
					}
					.textFieldStyle(.roundedBorder)
					.foregroundColor(Color.appBackground)
					.font(.zhip.title)
					
					Spacer()
					
					Checkbox(
						"I have securely backed up my encryption password",
						isOn: viewStore.binding(\.$userHasConfirmedBackingUpPassword)
					)
					
					Button("Continue") {
						viewStore.send(.continueButtonTapped)
					}
					.buttonStyle(.primary(isLoading: viewStore.isGeneratingWallet))
					.enabled(if: viewStore.isContinueButtonEnabled)
				}
#if DEBUG
				.onAppear {
					viewStore.send(.onAppear)
				}
#endif
				.alert(store.scope(state: \.alert), dismiss: .alertDismissed)
			}
		}
	}
}
