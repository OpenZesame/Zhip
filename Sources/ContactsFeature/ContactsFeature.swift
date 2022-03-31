//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-23.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import Screen
import Styleguide
import Wallet

public struct ContactsState: Equatable {
	public init() {}
}
public enum ContactsAction: Equatable {
	case delegate(DelegateAction)
}
public extension ContactsAction {
	enum DelegateAction: Equatable {
		case noop
	}
}

public struct ContactsEnvironment {
	public let mainQueue: AnySchedulerOf<DispatchQueue>
	public init(
		mainQueue: AnySchedulerOf<DispatchQueue>
	) {
		self.mainQueue = mainQueue
	}
}

public let contactsReducer = Reducer<ContactsState, ContactsAction, ContactsEnvironment> { state, action, environment in
	switch action {
	case .delegate(_):
		return .none
	}
}

public struct ContactsView: View {
	let store: Store<ContactsState, ContactsAction>
	public init(
		store: Store<ContactsState, ContactsAction>
	) {
		self.store = store
	}
}

public extension ContactsView {
	var body: some View {
		WithViewStore(store) { viewStore in
			ForceFullScreen {
				Text("Contacts")
					.font(.zhip.bigBang)
					.foregroundColor(.turquoise)
			}
			.navigationTitle("Contacts")
		}
	}
}
