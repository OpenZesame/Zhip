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

public enum DecryptKeystore {}

public extension DecryptKeystore {
	struct State: Equatable {
		public init() {
			
		}
	}
}

public extension DecryptKeystore {
	enum Action: Equatable {
		
	}
}
public extension DecryptKeystore {
	struct Environment {
		public init() {}
	}
}
public extension DecryptKeystore {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		return .none
	}
}


// MARK: - DecryptKeystoreToRevealKeyPairScreen
// MARK: -
public extension DecryptKeystore {
	struct Screen: View {
		let store: Store<State, Action>
		public init(store: Store<State, Action>) {
			self.store = store
		}
	}
}

// MARK: - View
// MARK: -
public extension DecryptKeystore.Screen {
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
