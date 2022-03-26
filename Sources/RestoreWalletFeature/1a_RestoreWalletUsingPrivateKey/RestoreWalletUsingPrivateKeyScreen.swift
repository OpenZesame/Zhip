//
//  RestoreWalletUsingPrivateKeyScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import ComposableArchitecture
import InputField
import Screen
import Styleguide
import SwiftUI
import Wallet
import struct Zesame.PrivateKey

public struct RestoreWalletUsingPrivateKeyState: Equatable {
	public init() {}
}
public enum RestoreWalletUsingPrivateKeyAction: Equatable {
	case delegate(DelegateAction)
}
public extension RestoreWalletUsingPrivateKeyAction {
	enum DelegateAction: Equatable {
		case finishedRestoringWalletFromPrivateKey(Wallet)
	}
}

public struct RestoreWalletUsingPrivateKeyEnvironment {
	public init() {}
}

public let restoreWalletUsingPrivateKeyReducer = Reducer<
	RestoreWalletUsingPrivateKeyState,
	RestoreWalletUsingPrivateKeyAction,
	RestoreWalletUsingPrivateKeyEnvironment
> { state, action, environment in
	return .none
}


// MARK: - RestoreWalletUsingPrivateKeyScreen
// MARK: -
public struct RestoreWalletUsingPrivateKeyScreen: View {
//    @ObservedObject var viewModel: RestoreWalletUsingPrivateKeyViewModel
	let store: Store<RestoreWalletUsingPrivateKeyState, RestoreWalletUsingPrivateKeyAction>
	public init(
		store: Store<RestoreWalletUsingPrivateKeyState, RestoreWalletUsingPrivateKeyAction>
	) {
		self.store = store
	}
}

// MARK: - View
// MARK: -
public extension RestoreWalletUsingPrivateKeyScreen {
    var body: some View {
		WithViewStore(store) { viewStore in
			ForceFullScreen {
				Text("Private Key")
					.font(.zhip.bigBang)
					.foregroundColor(.turquoise)
			}
			.navigationTitle("Restore with private key")
		}
//        ForceFullScreen {
//            VStack(spacing: 20) {
//                InputField.privateKey(text: $viewModel.privateKeyHex, isValid: $viewModel.isPrivateKeyValid)
//
//                PasswordInputFields(
//                    password: $viewModel.password,
//                    isPasswordValid: $viewModel.isPasswordValid,
//                    passwordConfirmation: $viewModel.passwordConfirmation,
//                    isPasswordConfirmationValid: $viewModel.isPasswordConfirmationValid
//                )
//
//                Button("Restore") {
//                    Task {
//                        await viewModel.restore()
//                    }
//                }
//                .buttonStyle(.primary(isLoading: $viewModel.isRestoringWallet))
//                .enabled(if: viewModel.canProceed)
//
//            }
//            .disableAutocorrection(true)
//        }
//        #if DEBUG
//        .onAppear {
//            viewModel.password = unsafeDebugPassword
//            viewModel.passwordConfirmation = unsafeDebugPassword
//            // Some uninteresting test account without any balance.
//            viewModel.privateKeyHex = "0xcc7d1263009ebbc8e31f5b7e7d79b625e57cf489cd540e1b0ac4801c8daab9be"
//        }
//        #endif
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
