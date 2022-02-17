//
//  DefaultTermsOfServiceViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation

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
