//
//  DefaultTermsOfServiceViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation

final class DefaultTermsOfServiceViewModel: TermsOfServiceViewModel {
    private unowned let navigator: Navigator
    private let useCase: OnboardingUseCase
    @Published var finishedReading: Bool = false
    
    init(navigator: Navigator, useCase: OnboardingUseCase) {
        self.navigator = navigator
        self.useCase = useCase
    }
    
    deinit {
        print("☑️ DefaultTermsOfServiceViewModel deinit")
    }
}

extension DefaultTermsOfServiceViewModel {
    func didAcceptTermsOfService() {
        useCase.didAcceptTermsOfService()
        navigator.step(.userDidAcceptTerms)
    }
}
