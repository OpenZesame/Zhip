//
//  TermsOfServiceScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import ComposableArchitecture
import Screen
import Styleguide
import SwiftUI
import UserDefaultsClient

public enum TermsOfService {}

public extension TermsOfService {
	struct State: Equatable {
		public var mode: Mode
		public var isAcceptButtonEnabled: Bool
		public init(
			mode: Mode = .mandatoryToAcceptTermsAsPartOfOnboarding
		) {
			self.mode = mode
			self.isAcceptButtonEnabled = mode == .mandatoryToAcceptTermsAsPartOfOnboarding ? false : true
		}
	}
}


public extension TermsOfService {
	enum Mode: Equatable {
		case mandatoryToAcceptTermsAsPartOfOnboarding
		case userInitiatedFromSettings
	}
}

public extension TermsOfService {
	enum Action: Equatable {
		case didFinishReading
		case acceptButtonTapped
		
		case delegate(Delegate)
	}
}
public extension TermsOfService.Action {
	enum Delegate: Equatable {
		case didAcceptTermsOfService, done
	}
}

public extension TermsOfService {
	struct Environment {
		public var userDefaults: UserDefaultsClient
		public init(
			userDefaults: UserDefaultsClient
		) {
			self.userDefaults = userDefaults
		}
	}
}

public extension TermsOfService {
	static let reducer = Reducer<State, Action, Environment> { state, action, environment in
		switch action {
			
		case .didFinishReading:
			state.isAcceptButtonEnabled = true
			return .none
			
		case .delegate(_):
			return .none
			
		case .acceptButtonTapped:
			return .concatenate(
				environment.userDefaults
					.setHasAcceptedTermsOfService(true)
					.fireAndForget(),
				
				Effect(value: .delegate(.didAcceptTermsOfService))
			)
		}
		
	}
}


// MARK: - TermsOfServiceScreen
// MARK: -

public extension TermsOfService {
	
	struct Screen: View {
		let store: Store<State, Action>
		
		public init(store: Store<State, Action>) {
			self.store = store
		}
	}
}

private extension TermsOfService.Screen {
	struct ViewState: Equatable {
		var mode: TermsOfService.Mode
		var isAcceptButtonEnabled: Bool
		var isAcceptButtonSupported: Bool
		var isAcceptDoneSupported: Bool
		init(state: TermsOfService.State) {
			self.mode = state.mode
			self.isAcceptButtonEnabled = state.isAcceptButtonEnabled
			self.isAcceptButtonSupported = state.mode == .mandatoryToAcceptTermsAsPartOfOnboarding
			self.isAcceptDoneSupported = state.mode == .userInitiatedFromSettings
		}
	}
	
}

// MARK: - View
// MARK: -
public extension TermsOfService.Screen {
	var body: some View {
		WithViewStore(
			store.scope(state: ViewState.init)
		) { viewStore in
			Screen {
				VStack {
					Image("Icons/Large/TermsOfService")
					
					Text("Terms of service").font(.largeTitle)
					
					ScrollView(.vertical) {
						// We must use `LazyVStack` instead of `VStack` here
						// because we don't want the `Color.clear` "view" to
						// get displayed eagerly, which it otherwise does.
						LazyVStack {
							Text(markdownAsAttributedString(markdownFileName: "TermsOfService"))
								.frame(maxHeight: .infinity)
							
							Color.clear
								.frame(size: 0, alignment: .bottom)
								.onAppear {
									viewStore.send(.didFinishReading)
								}
							
						}
					}
					
					if viewStore.isAcceptButtonSupported {
						Button("Accept") {
							viewStore.send(.acceptButtonTapped)
						}
						.buttonStyle(.primary)
						.enabled(if: viewStore.isAcceptButtonEnabled)
					}
				}
				.padding([.leading, .trailing, .bottom])
			}
			
			.toolbar {
#if os(iOS)
				ToolbarItem(placement: .navigationBarLeading) {
					if viewStore.isAcceptDoneSupported {
						Button(action: {
							viewStore.send(.delegate(.done))
						}, label: {
							Text("Done")
								.font(.zhip.hint)
								.foregroundColor(.white)
						})
					}
				}
#endif
			}
		}
	}
	
}


// MARK: - Markdown
// MARK: -
func markdownAsAttributedString(
	markdownFileName: String,
	textColor: Color = .white,
	font: Font = .body
) -> AttributedString {
	guard let path = Bundle.module.path(forResource: markdownFileName, ofType: "md") else {
		fatalError("bad path")
	}
	do {
		let markdownString = try String(contentsOfFile: path, encoding: .utf8)
		var attributedString = try AttributedString(
			markdown: markdownString,
			options: AttributedString.MarkdownParsingOptions(
				allowsExtendedAttributes: true,
				interpretedSyntax: .inlineOnlyPreservingWhitespace,
				failurePolicy: .throwError,
				languageCode: "en"
			),
			baseURL: nil
		)
		
		attributedString.font = font
		attributedString.foregroundColor = textColor
		
		return attributedString
	} catch {
		fatalError("Failed to read contents of file, error: \(error)")
	}
}
