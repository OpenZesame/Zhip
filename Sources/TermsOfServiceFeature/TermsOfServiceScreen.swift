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

public struct TermsOfServiceState: Equatable {
	public var mode: Mode
	public var isAcceptButtonEnabled: Bool
	public init(
		mode: Mode = .mandatoryToAcceptTermsAsPartOfOnboarding,
		isAcceptButtonEnabled: Bool? = nil // will default to value dependent on mode
	) {
		self.mode = mode
		self.isAcceptButtonEnabled = isAcceptButtonEnabled ?? (mode == .mandatoryToAcceptTermsAsPartOfOnboarding ? false : true)
	}
}

public extension TermsOfServiceState {
	enum Mode: Equatable {
		case mandatoryToAcceptTermsAsPartOfOnboarding
		case userInitiatedFromSettings
	}
}

public enum TermsOfServiceAction: Equatable {
	case didFinishReading
	case acceptButtonTapped
	
	case delegate(DelegateAction)
}
public extension TermsOfServiceAction {
	enum DelegateAction: Equatable {
		case didAcceptTermsOfService
	}
}

public struct TermsOfServiceEnvironment {
	public var userDefaults: UserDefaultsClient
	public init(
		userDefaults: UserDefaultsClient
	) {
		self.userDefaults = userDefaults
	}
}


public let termsOfServiceReducer = Reducer<TermsOfServiceState, TermsOfServiceAction, TermsOfServiceEnvironment> { state, action, environment in
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


// MARK: - TermsOfServiceScreen
// MARK: -
public struct TermsOfServiceScreen: View {
	let store: Store<TermsOfServiceState, TermsOfServiceAction>
	
	public init(store: Store<TermsOfServiceState, TermsOfServiceAction>) {
		self.store = store
	}
}

private extension TermsOfServiceScreen {
	struct ViewState: Equatable {
		var mode: TermsOfServiceState.Mode
		var isAcceptButtonEnabled: Bool
		init(state: TermsOfServiceState) {
			self.mode = state.mode
			self.isAcceptButtonEnabled = state.isAcceptButtonEnabled
		}
	}

}

// MARK: - View
// MARK: -
public extension TermsOfServiceScreen {
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
							termsOfService
								.frame(maxHeight: .infinity)
							
							Color.clear
								.frame(size: 0, alignment: .bottom)
								.onAppear {
									viewStore.send(.didFinishReading)
								}
							
						}
					}
					
					switch viewStore.state.mode {
					case .userInitiatedFromSettings:
						EmptyView()
					case .mandatoryToAcceptTermsAsPartOfOnboarding:
						Button("Accept") {
							viewStore.send(.acceptButtonTapped)
						}
						.buttonStyle(.primary)
						.enabled(if: viewStore.isAcceptButtonEnabled)
					}
				}
				.padding()
			}
		}
	}
	
}

// MARK: - Subviews
// MARK: -
private extension TermsOfServiceScreen {
  
    @ViewBuilder
    var termsOfService: some View {
        Text(markdownAsAttributedString(markdownFileName: "TermsOfService"))
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
