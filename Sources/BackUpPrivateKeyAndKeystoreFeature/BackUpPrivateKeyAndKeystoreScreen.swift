//
//  BackUpWalletScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-14.
//


import BackUpKeystoreFeature
import BackUpPrivateKeyFeature
import Checkbox
import ComposableArchitecture
import Screen
import Styleguide
import SwiftUI

public struct BackUpPrivateKeyAndKeystoreState: Equatable {
	
	public var backUpPrivateKey: BackUpPrivateKeyState
	public var backUpKeystore: BackUpKeystoreState
	public init(
		backUpPrivateKey: BackUpPrivateKeyState = .init(),
		backUpKeystore: BackUpKeystoreState = .init()
	) {
		self.backUpPrivateKey = backUpPrivateKey
		self.backUpKeystore = backUpKeystore
	}
}

public enum BackUpPrivateKeyAndKeystoreAction: Equatable {
}

public struct BackUpPrivateKeyAndKeystoreEnvironment {
	public init() {}
}

public let backUpPrivateKeyAndKeystoreReducer = Reducer<
	BackUpPrivateKeyAndKeystoreState,
	BackUpPrivateKeyAndKeystoreAction,
	BackUpPrivateKeyAndKeystoreEnvironment
> { state, action, environment in
	
	
	return .none
	
}


// MARK: - BackUpPrivateKeyAndKeystoreScreen
// MARK: -
public struct BackUpPrivateKeyAndKeystoreScreen: View {
//    @ObservedObject var viewModel: BackUpWalletViewModel
	let store: Store<BackUpPrivateKeyAndKeystoreState, BackUpPrivateKeyAndKeystoreAction>
	public init(
		store: Store<BackUpPrivateKeyAndKeystoreState, BackUpPrivateKeyAndKeystoreAction>
	) {
		self.store = store
	}
}

// MARK: - View
// MARK: -
public extension BackUpPrivateKeyAndKeystoreScreen {
    
    var body: some View {
		WithViewStore(
			store.scope(state: ViewState.init)
		) { viewStore in
        ForceFullScreen {
            VStack(spacing: 16) {
           
                Labels(
                    title: "Back up keys",
                    subtitle: "Backing up the private key is the most important, but is also the most sensitive data. The private key is not tied to the encryption password, but the keystore is. Failing to backup your wallet may result in irrevesible loss of assets."
                )
                
                backupViews.frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
//                switch viewModel.mode {
//                case .mandatoryBackUpPartOfOnboarding:
//                    Checkbox(
//                        "I have securely backed up my private key.",
//                        isOn: $viewModel.userHasConfirmedBackingUpWallet
//                    )
//
//                    Button("Continue") {
//                        viewModel.continue()
//                    }
//                    .buttonStyle(.primary)
//                    .disabled(!viewModel.isFinished)
//                case .userInitiatedFromSettings:
//                    EmptyView()
//                }
				Text("Code commented out")
            }
        }
//        .alert(isPresented: $viewModel.isPresentingDidCopyKeystoreAlert) {
//            Alert(
//                title: Text("Copied keystore to pasteboard."),
//                dismissButton: .default(Text("OK"))
//            )
//        }
		}
	}
    
}

// MARK: - Subviews
// MARK: -
private extension BackUpPrivateKeyAndKeystoreScreen {
    @ViewBuilder
    var backupViews: some View {
//        VStack(alignment: .leading) {
//            VStack(alignment: .leading) {
//                Text("Private key").font(.zhip.title)
//                HStack {
//                    Button("Reveal") {
//                        viewModel.revealPrivateKey()
//                    }.buttonStyle(.hollow)
//                    Spacer()
//                }
//            }
//            VStack(alignment: .leading) {
//                Text("Keystore").font(.zhip.title)
//                HStack {
//                    Button("Reveal") {
//                        viewModel.revealKeystore()
//                    }
//                    .buttonStyle(.hollow)
//
//                    Button("Copy") {
//                        viewModel.copyKeystoreToPasteboard()
//                    }.buttonStyle(.hollow)
//
//                    Spacer()
//                }
//            }
//        }
		Text("CODE COMMENTED OUT")
    }
    
}


// MARK: - Subviews
// MARK: -
private extension BackUpPrivateKeyAndKeystoreScreen {
	struct ViewState: Equatable {
		init(state: BackUpPrivateKeyAndKeystoreState) {
			
		}
	}
}
