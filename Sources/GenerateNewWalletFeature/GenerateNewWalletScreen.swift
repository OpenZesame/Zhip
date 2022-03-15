//
//  GenerateNewWalletScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-14.
//

import Checkbox
import ComposableArchitecture
import HoverPromptTextField
import InputField
import PasswordInputFields
import Screen
import Styleguide
import SwiftUI
import Wallet
import WalletGenerator

public struct GenerateNewWalletState: Equatable {
	
	@BindableState public var password: String
	@BindableState public var passwordConfirmation: String
	@BindableState public var isPasswordValid: Bool
	@BindableState public var isPasswordConfirmationValid: Bool
	@BindableState public var userHasConfirmedBackingUpPassword: Bool
	
	public var isContinueButtonEnabled: Bool
	public var isGeneratingWallet: Bool
	
	public init(
		password: String = "",
		passwordConfirmation: String = "",
		isPasswordValid: Bool = false,
		isPasswordConfirmationValid: Bool = false,
		userHasConfirmedBackingUpPassword: Bool = false,
		isContinueButtonEnabled: Bool = false,
		isGeneratingWallet: Bool = false
	) {
		self.password = password
		self.passwordConfirmation = passwordConfirmation
		self.isPasswordValid = isPasswordValid
		self.isPasswordConfirmationValid = isPasswordConfirmationValid
		self.userHasConfirmedBackingUpPassword = userHasConfirmedBackingUpPassword
		self.isContinueButtonEnabled = isContinueButtonEnabled
		self.isGeneratingWallet = isGeneratingWallet
	}
}

internal extension GenerateNewWalletState {
	var arePasswordsValidAndEqual: Bool {
		guard isPasswordValid && isPasswordConfirmationValid else { return false }
		guard
			password.count >= minimumEncryptionPasswordLength,
			passwordConfirmation.count >= minimumEncryptionPasswordLength
		else {
			return false
		}
		return password == passwordConfirmation
	}
}

public enum GenerateNewWalletAction: Equatable, BindableAction {
	
	case onAppear
	case continueButtonTapped
	
	case binding(BindingAction<GenerateNewWalletState>)
	case delegate(DelegateAction)
	
	case walletGenerationResult(Result<Wallet, WalletGeneratorError>)
}

public extension GenerateNewWalletAction {
	enum DelegateAction: Equatable {
		case finishedGeneratingNewWallet
	}
}

public struct GenerateNewWalletEnvironment {
	public let walletGenerator: WalletGenerator
	public let mainQueue: AnySchedulerOf<DispatchQueue>
	
	public init(
		walletGenerator: WalletGenerator,
		mainQueue: AnySchedulerOf<DispatchQueue>
	) {
		self.walletGenerator = walletGenerator
		self.mainQueue = mainQueue
	}
}

public let generateNewWalletReducer = Reducer<GenerateNewWalletState, GenerateNewWalletAction, GenerateNewWalletEnvironment> { state, action, environment in
	
	switch action {
	case .onAppear:
		#if DEBUG
		state.password = unsafeDebugPassword
		state.passwordConfirmation = unsafeDebugPassword
		state.userHasConfirmedBackingUpPassword = true
		#endif
		return .none
		
	case .binding:
		state.isContinueButtonEnabled = state.arePasswordsValidAndEqual && state.userHasConfirmedBackingUpPassword
		return .none
		
	case .continueButtonTapped:
		assert(state.arePasswordsValidAndEqual)
		state.isGeneratingWallet = true
		
		let request = GenerateWalletRequest(encryptionPassword: state.password, name: nil)
		
		return environment.walletGenerator
			.generate(request)
			.receive(on: environment.mainQueue)
			.catchToEffect(GenerateNewWalletAction.walletGenerationResult)
		
	case .walletGenerationResult(.success(let wallet)):
		print("🎉 Successfully generated wallet")
		return .none
	case .walletGenerationResult(.failure(let walletGenerationError)):
		print("❌ Failed to generate wallet, error: \(walletGenerationError)")
		return .none
		
	default:
		return .none
	}
}.binding()

// MARK: - GenerateNewWalletScreen
// MARK: -
public struct GenerateNewWalletScreen: View {
	let store: Store<GenerateNewWalletState, GenerateNewWalletAction>
	public init(store: Store<GenerateNewWalletState, GenerateNewWalletAction>) {
		self.store = store
	}
}

// MARK: - View
// MARK: -
public extension GenerateNewWalletScreen {
	
	var body: some View {
		WithViewStore(store) { viewStore in
			ForceFullScreen {
				VStack(spacing: 40) {
					
					Labels(
						title: "Set an encryption password",
						subtitle: "Your encryption password is used to encrypt your private key. Make sure to back up your encryption password before proceeding."
					)
					
					PasswordInputFields(
						password: viewStore.binding(\.$password),
						isPasswordValid: viewStore.binding(\.$isPasswordValid),
						passwordConfirmation: viewStore.binding(\.$passwordConfirmation),
						isPasswordConfirmationValid: viewStore.binding(\.$isPasswordConfirmationValid)
					)
					
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
				}.padding()
#if DEBUG
				.onAppear {
					viewStore.send(.onAppear)
				}
#endif
			}
		}
	}
}

#if DEBUG
let unsafeDebugPassword = "apabanan"
#endif
