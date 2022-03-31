//
//  ConfirmNewPINCodeScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-22.
//

import SwiftUI
import Styleguide
import Screen
import PINField
import Checkbox
import ComposableArchitecture

public struct ConfirmNewPINState: Equatable {
	public var expectedPIN: Pincode
	public init(expectedPIN: Pincode) {
		self.expectedPIN = expectedPIN
	}
}
public enum ConfirmNewPINAction: Equatable {
	case delegate(DelegateAction)
	case confirmPINButtonTapped
}
public extension ConfirmNewPINAction {
	enum DelegateAction: Equatable {
		case finishedConfirmingPIN(Pincode)
	}
}

public struct ConfirmNewPINEnvironment {
	public init() {}
}

public let confirmNewPINReducer = Reducer<
	ConfirmNewPINState,
	ConfirmNewPINAction,
	ConfirmNewPINEnvironment
> { state, action, environment in
	switch action {
	case .confirmPINButtonTapped:
		return Effect(value: .delegate(.finishedConfirmingPIN(state.expectedPIN)))
	case .delegate(_):
		return .none
	}
}

// MARK: - ConfirmNewPINScreen
// MARK: -
public struct ConfirmNewPINScreen: View {
	let store: Store<ConfirmNewPINState, ConfirmNewPINAction>
	public init(
		store: Store<ConfirmNewPINState, ConfirmNewPINAction>
	) {
		self.store = store
	}
}

// MARK: - View
// MARK: -
public extension ConfirmNewPINScreen {
	var body: some View {
		WithViewStore(
			store
		) { viewStore in
			ForceFullScreen {
				VStack {
					//                pinField
					//
					//                Checkbox(
					//                    "I have securely backed up my PIN code",
					//                    isOn: $viewModel.userHasConfirmedBackingUpPIN
					//                )
					//
					Button("Confirm") {
						viewStore.send(.confirmPINButtonTapped)
					}
					                .buttonStyle(.primary)
					//                .disabled(!viewModel.isFinished)
				}
				.navigationTitle("Confirm PIN")
				//				.toolbar {
				//					Button("Skip PIN") {
				//						viewModel.skipSettingAnyPIN()
				//					}
				//				}
				
			}
		}
	}
}

//private extension ConfirmNewPINCodeScreen {
//    var pinField: some View {
//        PINField(text: $viewModel.pinFieldText, pinCode: $viewModel.pinCode, errorMessage: viewModel.pinsDoNotMatchErrorMessage)
//    }
//}
