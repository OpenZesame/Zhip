//
//  DecryptKeystoreToRevealKeyPairScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-18.
//

import Combine
import ComposableArchitecture
import InputField
import Screen
import Styleguide
import SwiftUI


public struct DecryptKeystoreState: Equatable {
	public init() {
		
	}
}

public enum DecryptKeystoreAction: Equatable {
	
}

public struct DecryptKeystoreEnvironment {
	public init() {}
}

public let decryptKeystoreReducer = Reducer<DecryptKeystoreState, DecryptKeystoreAction, DecryptKeystoreEnvironment> { state, action, environment in
	return .none
}


// MARK: - DecryptKeystoreToRevealKeyPairScreen
// MARK: -
public struct DecryptKeystoreToRevealKeyPairScreen: View {
//    @ObservedObject var viewModel: DecryptKeystoreToRevealKeyPairViewModel
	let store: Store<DecryptKeystoreState, DecryptKeystoreAction>
	public init(store: Store<DecryptKeystoreState, DecryptKeystoreAction>) {
		self.store = store
	}
}

// MARK: - View
// MARK: -
public extension DecryptKeystoreToRevealKeyPairScreen {
    var body: some View {
//		WithViewStore(
//			state.scope()
//		)
        ForceFullScreen {
//            VStack {
//
//                Text("Enter your encryption password to reveal your private and public key.")
//
//                InputField(
//                    prompt: "Encryption password",
//                    text: $viewModel.password,
//                    isValid: $viewModel.isPasswordOnValidFormat,
//                    isSecure: true,
//                    validationRules: .encryptionPassword
//                )
//
//                Spacer()
//
//                Button("Reveal") {
//                    Task { @MainActor in
//                        await viewModel.decrypt()
//                    }
//                }
//                .disabled(!viewModel.canDecrypt)
//                .buttonStyle(.primary(isLoading: $viewModel.isDecrypting))
//            }
//            .navigationTitle("Decrypt keystore")
			Text("Code commented out")
        }
    }
}
