//
//  BackUpRevealedKeyPairScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import ComposableArchitecture
import Screen
import Styleguide
import SwiftUI

public enum BackUpRevealedKeyPair {}

public extension BackUpRevealedKeyPair {
	struct State: Equatable {
		public init() {
			
		}
	}
}

public extension BackUpRevealedKeyPair {
	enum Action: Equatable {
		
	}
}

public extension BackUpRevealedKeyPair {
	struct Environment {
		public init() {}
	}
}

public extension BackUpRevealedKeyPair {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		return .none
	}
}


// MARK: - BackUpRevealedKeyPairScreen
// MARK: -
public extension BackUpRevealedKeyPair {
	struct Screen: View {
		let store: Store<State, Action>
		public init(
			store: Store<State, Action>
		) {
			self.store = store
		}
	}
}

// MARK: - View
// MARK: -
public extension BackUpRevealedKeyPair.Screen {
	var body: some View {
		WithViewStore(
			store.scope(state: ViewState.init)
		) { viewStore in
			
			
			Text("Code commented out")
			//        ForceFullScreen {
			//            VStack(alignment: .leading, spacing: 16) {
			//                Text("Private key")
			//                    .font(.zhip.title)
			//                    .foregroundColor(.white)
			//
			//                Text("\(viewModel.displayablePrivateKey)")
			//                    .font(.zhip.body)
			//                    .textSelection(.enabled)
			//                    .foregroundColor(.white)
			//
			//                Button("Copy") {
			//                    viewModel.copyPrivateKeyToPasteboard()
			//                }
			//                .buttonStyle(.hollow)
			//
			//                Text("Public key (Uncompressed)")
			//                    .font(.zhip.title)
			//                    .foregroundColor(.white)
			//
			//                Text("\(viewModel.displayablePublicKey)")
			//                    .font(.zhip.body)
			//                    .textSelection(.enabled)
			//                    .foregroundColor(.white)
			//
			//                Button("Copy") {
			//                    viewModel.copyPublicKeyToPasteboard()
			//                }
			//                .buttonStyle(.hollow)
			//
			//                Spacer()
			//            }
			//            .alert(isPresented: $viewModel.isPresentingDidCopyToPasteboardAlert) {
			//                Alert(
			//                    title: Text("Copied to pasteboard."),
			//                    dismissButton: .default(Text("OK"))
			//                )
			//            }
			//        }
			//        .navigationTitle("Back up keys")
			//        .toolbar {
			//            Button("Done") {
			//                viewModel.doneBackingUpKeys()
			//            }
			//        }
		}
	}
}

private extension BackUpRevealedKeyPair.Screen {
	struct ViewState: Equatable {
		init(state: BackUpRevealedKeyPair.State) {
			
		}
	}
}
