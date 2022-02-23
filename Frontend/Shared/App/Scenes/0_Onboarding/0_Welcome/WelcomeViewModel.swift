//
//  WelcomeViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import Foundation

enum WelcomeNavigationStep {
    case didStart
}

protocol WelcomeViewModel: ObservableObject {
    func startApp()
}

extension WelcomeViewModel {
    typealias Navigator = NavigationStepper<WelcomeNavigationStep>
}

