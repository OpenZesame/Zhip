//
//  TermsOfServiceViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation
import ZhipEngine

enum TermsOfServiceNavigationStep {
    case userDidAcceptTerms
}

final class TermsOfServiceViewModel: ObservableObject {
    
    typealias Navigator = NavigationStepper<TermsOfServiceNavigationStep>
    
    private unowned let navigator: Navigator
    private let useCase: OnboardingUseCase
    @Published var finishedReading: Bool = false
    
    init(navigator: Navigator, useCase: OnboardingUseCase) {
        self.navigator = navigator
        self.useCase = useCase
    }
    
    deinit {
        print("☑️ TermsOfServiceViewModel deinit")
    }
}

extension TermsOfServiceViewModel {
    func didAcceptTermsOfService() {
        useCase.didAcceptTermsOfService()
        navigator.step(.userDidAcceptTerms)
    }
}
