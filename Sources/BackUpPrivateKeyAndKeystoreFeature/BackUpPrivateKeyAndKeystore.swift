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
import Common
import Screen
import Styleguide
import SwiftUI

public enum BackUpPrivateKeyAndKeystore {}

public extension BackUpPrivateKeyAndKeystore {
	
	enum Mode {
		case mandatoryBackUpPartOfOnboarding
		case userInitiatedFromSettings
	}
	
	
	struct State: Equatable {
		public var alert: AlertState<Action>?
		public var mode: Mode
		public var backUpPrivateKey: BackUpPrivateKey.State
		public var backUpKeystore: BackUpKeystore.State
		
		@BindableState public var userHasConfirmedBackingUpWallet: Bool
		public var canContinue: Bool
		
		public init(
			mode: Mode,
			backUpPrivateKey: BackUpPrivateKey.State = .init(),
			backUpKeystore: BackUpKeystore.State = .init(),
			alert: AlertState<Action>? = nil,
			userHasConfirmedBackingUpWallet: Bool = false,
			canContinue: Bool = false
		) {
			self.mode = mode
			
			self.backUpPrivateKey = backUpPrivateKey
			self.backUpKeystore = backUpKeystore
			
			self.alert = alert
			self.userHasConfirmedBackingUpWallet = userHasConfirmedBackingUpWallet
			self.canContinue = canContinue
		}
	}
}

public extension BackUpPrivateKeyAndKeystore {
	enum Action: Equatable, BindableAction {
		case binding(BindingAction<State>)
		case delegate(Delegate)
		case `internal`(Internal)
	}
}
public extension BackUpPrivateKeyAndKeystore.Action {
	enum Delegate: Equatable {
		case finishedBackingUpWallet
	}
	enum Internal: Equatable {
		case `continue`
		case copyKeystore
		case revealKeystore
		case revealPrivateKey
		case alertDismissed
	}

}

public extension BackUpPrivateKeyAndKeystore {
	struct Environment {
		public init() {}
	}
}

public extension BackUpPrivateKeyAndKeystore {
	static let reducer = Reducer<State, Action,	Environment> { state, action, environment in
		switch action {
		case .binding(_):
			state.canContinue = state.userHasConfirmedBackingUpWallet
			return .none
		case .internal(.continue):
			assert(state.userHasConfirmedBackingUpWallet)
			return Effect(value: .delegate(.finishedBackingUpWallet))
		case .internal(.alertDismissed):
			state.alert = nil
			return .none
		case .internal(.copyKeystore):
			//        .alert(isPresented: $viewModel.isPresentingDidCopyKeystoreAlert) {
			//            Alert(
			//                title: Text("Copied keystore to pasteboard."),
			//                dismissButton: .default(Text("OK"))
			//            )
			//        }
			guard copyToPasteboard(contents: "WHERE IS WALLET") else {
				return .none
			}
			state.alert = .init(title: TextState("Copied keystore to pasteboard."))
			return .none
		case .internal(.revealKeystore):
			fatalError()
		case .internal(.revealPrivateKey):
			fatalError()
		case .delegate(_):
			return .none
		}
	}
	.binding()
}


// MARK: - BackUpPrivateKeyAndKeystoreScreen
// MARK: -
public extension BackUpPrivateKeyAndKeystore {
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
public extension BackUpPrivateKeyAndKeystore.Screen {
	
	var body: some View {
		WithViewStore(
			store.scope(
				state: ViewState.init,
				action: BackUpPrivateKeyAndKeystore.Action.init
			)
		) { viewStore in
			ForceFullScreen {
				VStack(spacing: 16) {
					
					Labels(
						title: "Back up keys",
						subtitle: "Backing up the private key is the most important, but is also the most sensitive data. The private key is not tied to the encryption password, but the keystore is. Failing to backup your wallet may result in irrevesible loss of assets."
					)
					
					VStack(alignment: .leading) {
						VStack(alignment: .leading) {
							Text("Private key").font(.zhip.title)
							HStack {
								Button("Reveal") {
									viewStore.send(.revealPrivateKeyButtonTapped)
								}.buttonStyle(.hollow)
								Spacer()
							}
						}
						VStack(alignment: .leading) {
							Text("Keystore").font(.zhip.title)
							HStack {
								Button("Reveal") {
									viewStore.send(.revealKeystoreButtonTapped)
								}
								.buttonStyle(.hollow)
			
								Button("Copy") {
									viewStore.send(.copyKeystoreButtonTapped)
								}.buttonStyle(.hollow)
			
								Spacer()
							}
						}
					}
					.frame(maxWidth: .infinity, alignment: .leading)
					
					Spacer()
					
					switch viewStore.mode {
					case .mandatoryBackUpPartOfOnboarding:
						Checkbox(
							"I have securely backed up my private key.",
							isOn: viewStore.binding(\.$userHasConfirmedBackingUpWallet)
						)
						
						Button("Continue") {
							viewStore.send(.continueButtonTapped)
						}
						.buttonStyle(.primary)
						.disabled(!viewStore.canContinue)
					case .userInitiatedFromSettings:
						EmptyView()
					}
				}
			}
			.alert(store.scope(state: \.alert), dismiss: .internal(.alertDismissed))
		}
	}
	
}

// MARK: - ViewState
// MARK: -
private extension BackUpPrivateKeyAndKeystore.Screen {
	struct ViewState: Equatable {
		let mode: BackUpPrivateKeyAndKeystore.Mode
		@BindableState var userHasConfirmedBackingUpWallet: Bool
		let canContinue: Bool
		init(state: BackUpPrivateKeyAndKeystore.State) {
			self.mode = state.mode
			self.canContinue = state.canContinue
			self.userHasConfirmedBackingUpWallet = state.userHasConfirmedBackingUpWallet
		}
	}
	
	enum ViewAction: Equatable, BindableAction {
		case binding(BindingAction<ViewState>)
		case continueButtonTapped
		case revealPrivateKeyButtonTapped
		case revealKeystoreButtonTapped
		case copyKeystoreButtonTapped
	}
}

extension BackUpPrivateKeyAndKeystore.State {
	fileprivate var view: BackUpPrivateKeyAndKeystore.Screen.ViewState {
		get { .init(state: self) }
		set {
			// handle bindable actions only:
			self.userHasConfirmedBackingUpWallet = newValue.userHasConfirmedBackingUpWallet
		}
	}
}

private extension BackUpPrivateKeyAndKeystore.Action {
	init(action: BackUpPrivateKeyAndKeystore.Screen.ViewAction) {
		switch action {
		case let .binding(bindingAction):
			self = .binding(bindingAction.pullback(\BackUpPrivateKeyAndKeystore.State.view))
		case .continueButtonTapped:
			self = .internal(.continue)
		case .copyKeystoreButtonTapped:
			self = .internal(.copyKeystore)
		case .revealKeystoreButtonTapped:
			self = .internal(.revealKeystore)
		case .revealPrivateKeyButtonTapped:
			self = .internal(.revealPrivateKey)
	
		}
	}
}
