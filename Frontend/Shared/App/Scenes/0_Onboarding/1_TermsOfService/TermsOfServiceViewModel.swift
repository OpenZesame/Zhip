//
//  TermsOfServiceViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation

enum TermsOfServiceNavigationStep {
    case userDidAcceptTerms
}

protocol TermsOfServiceViewModel: ObservableObject {
    var finishedReading: Bool { get set }
    func didAcceptTermsOfService()
}

extension TermsOfServiceViewModel {
    typealias Navigator = NavigationStepper<TermsOfServiceNavigationStep>
}
