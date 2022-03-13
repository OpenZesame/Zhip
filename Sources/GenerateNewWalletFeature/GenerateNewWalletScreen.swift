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
import Screen
import Styleguide
import SwiftUI

public struct GenerateNewWalletState: Equatable {
	public init() {}
}
public enum GenerateNewWalletAction: Equatable {
	case delegate(DelegateAction)
}
public extension GenerateNewWalletAction {
	enum DelegateAction: Equatable {
		case finishedGeneratingNewWallet
	}
}

public struct GenerateNewWalletEnvironment {
	public init() {}
}

public let generateNewWalletReducer = Reducer<GenerateNewWalletState, GenerateNewWalletAction, GenerateNewWalletEnvironment> { state, action, environment in
	return .none
}

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
		WithViewStore(
			store.scope(state: ViewState.init)
		) { viewStore in
			ForceFullScreen {
				VStack(spacing: 40) {
					
					Labels(
						title: "Set an encryption password",
						subtitle: "Your encryption password is used to encrypt your private key. Make sure to back up your encryption password before proceeding."
					)
					
//					PasswordInputFields(
//						password: $viewModel.password,
//						isPasswordValid: $viewModel.isPasswordValid,
//						passwordConfirmation: $viewModel.passwordConfirmation,
//						isPasswordConfirmationValid: $viewModel.isPasswordConfirmationValid
//					)
					Text("PASSWORD INPUT FIELDS COMMENTED OUT")
					
					Spacer()
					
//					Checkbox(
//						"I have securely backed up my encryption password",
//						isOn: $viewModel.userHasConfirmedBackingUpPassword
//					)
					Text("Checkbox commented out")
					
//					Button("Continue") {
//						Task { @MainActor in
//							await viewModel.continue()
//						}
//					}
//					.buttonStyle(.primary(isLoading: $viewModel.isGeneratingWallet))
//					.enabled(if: viewModel.canProceed)
					Text("Contine button commented out")
				}
#if DEBUG
				.onAppear {
//					viewModel.password = unsafeDebugPassword
//					viewModel.passwordConfirmation = unsafeDebugPassword
//					viewModel.userHasConfirmedBackingUpPassword = true
					print("onAppear logic commted out!")
				}
#endif
			}
		}
	}
}

#if DEBUG
let unsafeDebugPassword = "apabanan"
#endif

private extension GenerateNewWalletScreen {
	struct ViewState: Equatable {
		init(state: GenerateNewWalletState) {
			
		}
	}
}

extension Array where Element == ValidateInputRequirement {
    static var encryptionPassword: [ValidateInputRequirement] {
       [
        ValidateInputRequirement.encryptionPassword
       ]
    }
}

extension ValidateInputRequirement {
    static let encryptionPassword: ValidateInputRequirement = { ValidateInputRequirement.minimumLength(of: 8) as! ValidateInputRequirement }()
}

struct PasswordInputFields: View {
    
    @Binding var password: String
    @Binding var isPasswordValid: Bool
    @Binding var passwordConfirmation: String
    @Binding var isPasswordConfirmationValid: Bool
    
    var body: some View {
        VStack(spacing: 20) {
 
            InputField.encryptionPassword(
                text: $password,
                isValid: $isPasswordValid
            )
            
            InputField.encryptionPassword(
                prompt: "Confirm encryption password",
                text: $passwordConfirmation,
                isValid: $isPasswordConfirmationValid,
                additionalValidationRules: [
                    Validation { confirmText in
                        if confirmText != password {
                            return "Passwords does not match."
                        }
                        return nil // Valid
                    }
                ]
            )
        }
    }
}

extension InputField {
    static func encryptionPassword(
        prompt: String = "Encryption password",
        text: Binding<String>,
        isValid: Binding<Bool>? = nil,
        additionalValidationRules: [Validation] = []
    ) -> Self {
        Self(
            prompt: prompt,
            text: text,
            isValid: isValid,
            isSecure: true,
            validationRules: [ValidateInputRequirement.encryptionPassword] + additionalValidationRules
        )
    }
}
