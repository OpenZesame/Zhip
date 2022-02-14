//
//  TermsOfServiceScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen

protocol TermsOfServiceViewModel: ObservableObject {
    var finishedReading: Bool { get set }
    func didAcceptTermsOfService()
}

final class DefaultTermsOfServiceViewModel: TermsOfServiceViewModel {
    private unowned let coordinator: OnboardingCoordinator
    private let useCase: OnboardingUseCase
    @Published var finishedReading: Bool = false
    
    init(coordinator: OnboardingCoordinator, useCase: OnboardingUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
}

extension DefaultTermsOfServiceViewModel {
    func didAcceptTermsOfService() {
        useCase.didAcceptTermsOfService()
        coordinator.didAcceptTermsOfService()
    }
}

struct TermsOfServiceScreen<ViewModel: TermsOfServiceViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        Screen {
            VStack {
                Image("Icons/Large/TermsOfService")
                
                Text("Terms of service").font(.largeTitle).foregroundColor(.white)
                
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
                
                Button("Accept") {
                    viewModel.didAcceptTermsOfService()
                }
                .buttonStyle(.primary)
                .disabled(!viewModel.finishedReading)
            }
            .padding()
        }
    }
    
    @ViewBuilder var termsOfService: some View {
        Text(markdownAsAttributedString(markdownFileName: "TermsOfService"))
    }
    
    /// Must be wrapped in a `LazyVStack` and not `VStack`
    @ViewBuilder var detectIfBottomOfScrollViewProxy: some View {
        Color.clear
            .frame(width: 0, height: 0, alignment: .bottom)
            .onAppear {
                viewModel.finishedReading = true
            }
    }
}

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
