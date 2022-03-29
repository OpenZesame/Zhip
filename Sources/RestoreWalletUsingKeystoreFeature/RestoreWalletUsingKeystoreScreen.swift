//
//  RestoreWalletUsingKeystoreScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import ComposableArchitecture
import InputField
import SwiftUI
import Styleguide
import Screen
import Wallet

public struct RestoreWalletUsingKeystoreState: Equatable {
	public init() {}
}
public enum RestoreWalletUsingKeystoreAction: Equatable {
	case delegate(DelegateAction)
}
public extension RestoreWalletUsingKeystoreAction {
	enum DelegateAction: Equatable {
		case finishedRestoringWalletFromKeystore(Wallet)
	}
}

public struct RestoreWalletUsingKeystoreEnvironment {
	public init() {}
}

public let restoreWalletUsingKeystoreReducer = Reducer<
	RestoreWalletUsingKeystoreState,
	RestoreWalletUsingKeystoreAction,
	RestoreWalletUsingKeystoreEnvironment
> { state, action, environment in
	return .none
}


public struct RestoreWalletUsingKeystoreScreen: View {
//    @ObservedObject var viewModel: RestoreWalletUsingKeystoreViewModel
	let store: Store<RestoreWalletUsingKeystoreState, RestoreWalletUsingKeystoreAction>

	public init(
		store: Store<RestoreWalletUsingKeystoreState, RestoreWalletUsingKeystoreAction>
	) {
		self.store = store
	}
}

// MARK: - View
// MARK: -
public extension RestoreWalletUsingKeystoreScreen {
	var body: some View {
		WithViewStore(store) { viewStore in
			ForceFullScreen {
				//            VStack {
				//                TextEditor(text: $viewModel.keystoreString)
				//                    .foregroundColor(Color.deepBlue)
				//                    .font(.zhip.body)
				//
				//                if !viewModel.isKeystoreValid {
				//                    Text("Invalid keystore")
				//                        .foregroundColor(.bloodRed)
				//                }
				//
				//                InputField.encryptionPassword(
				//                    text: $viewModel.encryptionPassword,
				//                    isValid: $viewModel.isEncryptionPasswordValid
				//                )
				//
				//                Button("Restore") {
				//                    Task {
				//                        await viewModel.restore()
				//                    }
				//                }
				//                .buttonStyle(.primary(isLoading: $viewModel.isRestoringWallet))
				//                .enabled(if: viewModel.canProceed)
				//            }
				Text("Keystore")
					.font(.zhip.bigBang)
					.foregroundColor(.turquoise)
			}
			.navigationTitle("Restore with keystore")
		}
	}
}
