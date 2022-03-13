//
//  TermsOfServiceScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Styleguide
import Screen

// MARK: - TermsOfServiceScreen
// MARK: -
struct TermsOfServiceScreen: View {
    @ObservedObject var viewModel: TermsOfServiceViewModel
}

// MARK: - View
// MARK: -
extension TermsOfServiceScreen {
    var body: some View {
        Screen {
            VStack {
                Image("Icons/Large/TermsOfService")
                
                Text("Terms of service").font(.largeTitle)
                
                termsOfServiceScrollView
                
                switch viewModel.mode {
                case .userInitiatedFromSettings:
                    EmptyView()
                case .mandatoryToAcceptTermsAsPartOfOnboarding:
                    Button("Accept") {
                        viewModel.didAcceptTermsOfService()
                    }
                    .buttonStyle(.primary)
                    .disabled(!viewModel.finishedReading)
                }
            }
            .padding()
        }
    }
    
}

// MARK: - Subviews
// MARK: -
private extension TermsOfServiceScreen {
    
    @ViewBuilder
    var termsOfServiceScrollView: some View {
        ScrollView(.vertical) {
            // We must use `LazyVStack` instead of `VStack` here
            // because we don't want the `Color.clear` "view" to
            // get displayed eagerly, which it otherwise does.
            LazyVStack {
                termsOfService
                    .frame(maxHeight: .infinity)
                
                detectIfBottomOfScrollViewProxy
                
            }
        }
    }
    
    @ViewBuilder
    var termsOfService: some View {
        Text(markdownAsAttributedString(markdownFileName: "TermsOfService"))
    }
    
    /// Must be wrapped in a `LazyVStack` and not `VStack`
    @ViewBuilder
    var detectIfBottomOfScrollViewProxy: some View {
        Color.clear
            .frame(size: 0, alignment: .bottom)
            .onAppear {
                viewModel.finishedReading = true
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
    guard let path = Bundle.main.path(forResource: markdownFileName, ofType: "md") else {
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
