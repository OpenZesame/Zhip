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


public struct BackUpKeystoreState: Equatable {
	public init() {
		
	}
}

public enum BackUpKeystoreAction: Equatable {
	
}

public struct BackUpKeystoreEnvironment {
	public init() {}
}

public let backUpKeystoreReducer = Reducer<BackUpKeystoreState, BackUpKeystoreAction, BackUpKeystoreEnvironment> { state, action, environment in
	return .none
}



// MARK: - BackUpKeystoreScreen
// MARK: -
public struct BackUpKeystoreScreen: View {
//    @ObservedObject var viewModel: BackUpKeystoreViewModel
	let store: Store<BackUpKeystoreState, BackUpKeystoreAction>
	public init(store: Store<BackUpKeystoreState, BackUpKeystoreAction>) {
		self.store = store
	}
}

// MARK: - View
// MARK: -
public extension BackUpKeystoreScreen {
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

private extension BackUpKeystoreScreen {
	struct ViewState: Equatable {
		init(state: BackUpKeystoreState) {
			
		}
	}
}
