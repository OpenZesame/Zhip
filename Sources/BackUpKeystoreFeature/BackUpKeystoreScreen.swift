//
//  RevealKeystoreScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Combine
import ComposableArchitecture
import Screen
import Styleguide
import SwiftUI

public enum BackUpKeystore {}

public extension BackUpKeystore {
	struct State: Equatable {
		public init() {
			
		}
	}
}

public extension BackUpKeystore {
	enum Action: Equatable {
		
	}
}

public extension BackUpKeystore {
	struct Environment {
		public init() {}
	}
}

public extension BackUpKeystore {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		return .none
	}
}



// MARK: - BackUpKeystoreScreen
// MARK: -

public extension BackUpKeystore {
	struct Screen: View {
		let store: Store<State, Action>
		public init(store: Store<State, Action>) {
			self.store = store
		}
	}
}

// MARK: - View
// MARK: -
public extension BackUpKeystore.Screen {
	var body: some View {
		WithViewStore(
			store.scope(state: ViewState.init)
		) { viewStore in
			Text("Code commented out")
			//        ForceFullScreen {
			//            VStack {
			//                ScrollView {
			//                    Text(viewModel.displayableKeystore)
			//                        .textSelection(.enabled)
			//                }
			//                Button("Copy keystore") {
			//                    viewModel.copyKeystoreToPasteboard()
			//                }
			//                .buttonStyle(.primary)
			//            }
			//            .alert(isPresented: $viewModel.isPresentingDidCopyKeystoreAlert) {
			//                Alert(
			//                    title: Text("Copied keystore to pasteboard."),
			//                    dismissButton: .default(Text("OK"))
			//                )
			//            }
			//        }
			//        .navigationTitle("Back up keystore")
			//        .toolbar {
			//            Button("Done") {
			//                viewModel.doneBackingUpKeystore()
			//            }
			//        }
		}
	}
}

private extension BackUpKeystore.Screen {
	struct ViewState: Equatable {
		init(state: BackUpKeystore.State) {
			
		}
	}
}
