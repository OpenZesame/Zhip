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
import KeychainClient

public struct GenerateNewWalletState: Equatable {
	
	
	@BindableState public var password: String
	@BindableState public var passwordConfirmation: String
	@BindableState public var userHasConfirmedBackingUpPassword: Bool
	
	public var isContinueButtonEnabled: Bool
	public var isGeneratingWallet: Bool

	public var alert: AlertState<GenerateNewWalletAction>?
	
	public init(
		password: String = "",
		passwordConfirmation: String = "",
		userHasConfirmedBackingUpPassword: Bool = false,
		isContinueButtonEnabled: Bool = false,
		isGeneratingWallet: Bool = false,
		alert: AlertState<GenerateNewWalletAction>? = nil
	) {
		self.password = password
		self.passwordConfirmation = passwordConfirmation
		self.userHasConfirmedBackingUpPassword = userHasConfirmedBackingUpPassword
		self.isContinueButtonEnabled = isContinueButtonEnabled
		self.isGeneratingWallet = isGeneratingWallet
		self.alert = alert
	}
}

internal extension GenerateNewWalletState {
	
	static func validate(password: String) -> Bool {
		guard
			password.count >= minimumEncryptionPasswordLength
		else {
			return false
		}
		return true
	}
	
	
	var arePasswordsValid: Bool {
		guard Self.validate(password: password) && Self.validate(password: passwordConfirmation) else { return false }
		return true
	}
	
	var arePasswordsValidAndEqual: Bool {
		guard arePasswordsValid else { return false }
		return password == passwordConfirmation
	}
}

public enum GenerateNewWalletAction: Equatable, BindableAction {
	case alertDismissed
	case onAppear
	case continueButtonTapped
	
	case binding(BindingAction<GenerateNewWalletState>)
	case delegate(DelegateAction)
	
	case walletGenerationResult(Result<Wallet, WalletGeneratorError>)
}

public extension GenerateNewWalletAction {
	enum DelegateAction: Equatable {
		case finishedGeneratingNewWallet(Wallet)
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
		state.isGeneratingWallet = false
		return Effect(value: .delegate(.finishedGeneratingNewWallet(wallet)))
		
	case .walletGenerationResult(.failure(let walletGenerationError)):
		state.isGeneratingWallet = false
		state.alert = .init(title: TextState("Failed to generate wallet, reason: \(String(describing: walletGenerationError))"))
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

#if DEBUG
let unsafeDebugPassword = "apabanan"
#endif
