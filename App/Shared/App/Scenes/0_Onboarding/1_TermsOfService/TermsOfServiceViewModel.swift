//
//  TermsOfServiceViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation
import ZhipEngine

public enum TermsOfServiceNavigationStep {
    case userDidAcceptTerms
}

public final class TermsOfServiceViewModel: ObservableObject {
    
    
    private unowned let navigator: Navigator
    private let useCase: OnboardingUseCase
    @Published var finishedReading: Bool
    
    public let mode: Mode
    
    init(mode: Mode, navigator: Navigator, useCase: OnboardingUseCase) {
        self.mode = mode
        self.navigator = navigator
        self.useCase = useCase
        self.finishedReading = mode == .userInitiatedFromSettings
    }
    
    deinit {
        print("☑️ TermsOfServiceViewModel deinit")
    }
}


public extension TermsOfServiceViewModel {
    
    enum Mode {
        case mandatoryToAcceptTermsAsPartOfOnboarding
        case userInitiatedFromSettings
    }
    
    typealias Navigator = NavigationStepper<TermsOfServiceNavigationStep>
   
    
    func didAcceptTermsOfService() {
        useCase.didAcceptTermsOfService()
        navigator.step(.userDidAcceptTerms)
    }
}
