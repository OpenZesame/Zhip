//
//  TermsOfServiceScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen

protocol TermsOfServiceViewModel: ObservableObject {
    var finishedReading: Bool { get }
    func didAcceptTermsOfService()
    func scrolled(to offset: CGFloat, of height: CGFloat)
    var terms: AttributedString { get }
}

final class DefaultTermsOfServiceViewModel: TermsOfServiceViewModel {
    private unowned let coordinator: OnboardingCoordinator
    private let useCase: OnboardingUseCase
    @Published var finishedReading: Bool = false
    
    let terms: AttributedString
    
    init(coordinator: OnboardingCoordinator, useCase: OnboardingUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
        //        self.terms = htmlAsAttributedString(htmlFileName: "TermsOfService")
        self.terms = markdownAsAttributedString(markdownFileName: "TermsOfService")
    }
}

extension DefaultTermsOfServiceViewModel {
    func didAcceptTermsOfService() {
        useCase.didAcceptTermsOfService()
        coordinator.didAcceptTermsOfService()
    }
    func scrolled(to offset: CGFloat, of height: CGFloat) {
        let yThreshold: CGFloat = 0.98
        finishedReading = offset >= yThreshold * height
    }
    
    
}

struct TermsOfServiceScreen<ViewModel: TermsOfServiceViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        Screen {
            VStack {
                Image("Icons/Large/TermsOfService")
                
                Text("Terms of service").font(.largeTitle).foregroundColor(.white)
                
//                GeometryReader { outerProxy in
                    ScrollView(.vertical) {
//                        GeometryReader { innerProxy in
                                Text(viewModel.terms)
                                    .frame(maxHeight: .infinity)
//                                    .onAppear {
//                                        viewModel.scrolled(
//                                            to: outerProxy.frame(in: .global).minY - innerProxy.frame(in: .global).minY,
//                                            of: innerProxy.size.height
//                                        )
//                                    }
//                            }
//                        }
                }
                
                Button("Accept") {
                    viewModel.didAcceptTermsOfService()
                }
                .buttonStyle(.primary)
                .disabled(viewModel.finishedReading)
            }
            .padding()
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
