//
//  TermsOfServiceScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen

protocol TermsOfServiceViewModel: ObservableObject {
    func didAcceptTermsOfService()
}

final class DefaultTermsOfServiceViewModel: TermsOfServiceViewModel {
    private unowned let coordinator: OnboardingCoordinator
    private let useCase: OnboardingUseCase
    
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
        VStack {
            Text("Terms of Service")
            Button("Accept") {
                viewModel.didAcceptTermsOfService()
            }
            .buttonStyle(.primary)
        }
        
    }
}
