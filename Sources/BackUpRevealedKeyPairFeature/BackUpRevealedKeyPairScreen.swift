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

public struct BackUpRevealedKeyPairState: Equatable {
	public init() {
		
	}
}

public enum BackUpRevealedKeyPairAction: Equatable {
	
}

public struct BackUpRevealedKeyPairEnvironment {
	public init() {}
}

public let backUpRevealedKeyPairReducer = Reducer<BackUpRevealedKeyPairState, BackUpRevealedKeyPairAction, BackUpRevealedKeyPairEnvironment> { state, action, environment in
	return .none
}


// MARK: - BackUpRevealedKeyPairScreen
// MARK: -
public struct BackUpRevealedKeyPairScreen: View {
//    @ObservedObject var viewModel: BackUpRevealedKeyPairViewModel
	let store: Store<BackUpRevealedKeyPairState, BackUpRevealedKeyPairAction>
	public init(
		store: Store<BackUpRevealedKeyPairState, BackUpRevealedKeyPairAction>
	) {
		self.store = store
	}
}

// MARK: - View
// MARK: -
public extension BackUpRevealedKeyPairScreen {
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

private extension BackUpRevealedKeyPairScreen {
	struct ViewState: Equatable {
		init(state: BackUpRevealedKeyPairState) {
			
		}
	}
}
