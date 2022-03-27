//
//  RestoreWalletUsingPrivateKeyScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Common
import ComposableArchitecture
import InputField
import PasswordValidator
import Screen
import Styleguide
import SwiftUI
import Wallet
import struct Zesame.PrivateKey

public struct RestoreWalletUsingPrivateKeyState: Equatable {
	public var isRestoring: Bool
	public var canRestore: Bool
	@BindableState public var privateKeyHex: String
	@BindableState public var password: String
	@BindableState public var passwordConfirmation: String
	
	public init(
		isRestoring: Bool = false,
		canRestore: Bool = false,
		privateKeyHex: String = "",
		password: String = "",
		passwordConfirmation: String = ""
	) {
		self.isRestoring = isRestoring
		
		self.canRestore = canRestore
		self.privateKeyHex = privateKeyHex
		self.password = password
		self.passwordConfirmation = passwordConfirmation
	
#if DEBUG
		// Some uninteresting test account without any balance.
		self.privateKeyHex = "0xcc7d1263009ebbc8e31f5b7e7d79b625e57cf489cd540e1b0ac4801c8daab9be"

//		self.password = unsafeDebugPassword
//		self.passwordConfirmation = unsafeDebugPassword
#endif
	}
}
public enum RestoreWalletUsingPrivateKeyAction: Equatable, BindableAction {
	case binding(BindingAction<RestoreWalletUsingPrivateKeyState>)
	case delegate(DelegateAction)
	
	case restore
}
public extension RestoreWalletUsingPrivateKeyAction {
	enum DelegateAction: Equatable {
		case finishedRestoringWalletFromPrivateKey(Wallet)
	}
}

public struct RestoreWalletUsingPrivateKeyEnvironment {
	public var passwordValidator: PasswordValidator
	public init(passwordValidator: PasswordValidator) {
		self.passwordValidator = passwordValidator
	}
}

public let restoreWalletUsingPrivateKeyReducer = Reducer<
	RestoreWalletUsingPrivateKeyState,
	RestoreWalletUsingPrivateKeyAction,
	RestoreWalletUsingPrivateKeyEnvironment
> { state, action, environment in
	switch action {
	case .binding(_):
		state.canRestore = environment.passwordValidator
			.validatePasswords(
				.init(
					password: state.password,
					confirmPassword: state.passwordConfirmation
				)
			) && PrivateKey(hex: state.privateKeyHex) != nil
		return .none
		
	case .restore:
		fatalError()
	case .delegate(_):
		return .none
	}
}.binding()


// MARK: - RestoreWalletUsingPrivateKeyScreen
// MARK: -
public struct RestoreWalletUsingPrivateKeyScreen: View {

	let store: Store<RestoreWalletUsingPrivateKeyState, RestoreWalletUsingPrivateKeyAction>
	public init(
		store: Store<RestoreWalletUsingPrivateKeyState, RestoreWalletUsingPrivateKeyAction>
	) {
		self.store = store
	}
}

internal extension RestoreWalletUsingPrivateKeyScreen {
	struct ViewState: Equatable {
		var isRestoring: Bool
		var canRestore: Bool
		@BindableState var privateKeyHex: String
		@BindableState var password: String
		@BindableState var passwordConfirmation: String
		
		init(state: RestoreWalletUsingPrivateKeyState) {
			self.isRestoring = state.isRestoring
			self.canRestore = state.canRestore
			self.privateKeyHex = state.privateKeyHex
			self.password = state.password
			self.passwordConfirmation = state.passwordConfirmation
		}
	}
	
	enum ViewAction: Equatable, BindableAction {
		case binding(BindingAction<ViewState>)
		case restoreButtonTapped
	}
}

extension RestoreWalletUsingPrivateKeyState {
	fileprivate var view: RestoreWalletUsingPrivateKeyScreen.ViewState {
		get { .init(state: self) }
		set {
			// handle bindable actions only:
			self.privateKeyHex = newValue.privateKeyHex
			self.password = newValue.password
			self.passwordConfirmation = newValue.passwordConfirmation
		}
	}
}


private extension RestoreWalletUsingPrivateKeyAction {
	init(action: RestoreWalletUsingPrivateKeyScreen.ViewAction) {
		switch action {
		case let .binding(bindingAction):
			self = .binding(bindingAction.pullback(\RestoreWalletUsingPrivateKeyState.view))
		case .restoreButtonTapped:
			self = .restore
		}
	}
}

// MARK: - View
// MARK: -
public extension RestoreWalletUsingPrivateKeyScreen {
    var body: some View {
		WithViewStore(
			store.scope(
				state: ViewState.init,
				action: RestoreWalletUsingPrivateKeyAction.init
			)
		) { viewStore in
			ForceFullScreen {
				VStack(spacing: 20) {
					
	//					InputField.privateKey(text: viewStore.privateKeyHex, isValid: $viewModel.isPrivateKeyValid)
					SecureField("Private Key Hex", text: viewStore.binding(\.$privateKeyHex))
					
					
	//					PasswordInputFields(
	 //						password: $viewModel.password,
	 //						isPasswordValid: $viewModel.isPasswordValid,
	 //						passwordConfirmation: $viewModel.passwordConfirmation,
	 //						isPasswordConfirmationValid: $viewModel.isPasswordConfirmationValid
	 //					)
					SecureField("Encryption password", text: viewStore.binding(\.$password))
					SecureField("Confirm encryption password", text: viewStore.binding(\.$passwordConfirmation))


					Button("Restore") {
						viewStore.send(.restoreButtonTapped)
					}
					.buttonStyle(.primary(isLoading: viewStore.isRestoring))
					.enabled(if: viewStore.canRestore)

				}
				.foregroundColor(Color.asphaltGrey)
				.textFieldStyle(.roundedBorder)
				.disableAutocorrection(true)
			}
			.navigationTitle("Restore with private key")
		}

    }
}

//extension InputField {
//    static func privateKey(
//        prompt: String = "Private Key",
//        text: Binding<String>,
//        isValid: Binding<Bool>? = nil
//    ) -> Self {
//        Self(
//            prompt: prompt,
//            text: text,
//            isValid: isValid,
//            isSecure: true,
//            maxLength: 66, // "0x" + 64 hex private key chars => max length 66.
//            characterRestriction: .onlyContains(whitelisted: .hexadecimalDigitsIncluding0x),
//            validationRules: [
//                Validation { privateKeyHex in
//                    if PrivateKey(hex: privateKeyHex) == nil {
//                        return "Invalid private key."
//                    }
//                    return nil // Valid
//                },
//            ]
//        )
//    }
//}
