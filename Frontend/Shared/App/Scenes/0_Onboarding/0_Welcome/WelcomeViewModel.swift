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

final class WelcomeViewModel: ObservableObject {
    typealias Navigator = NavigationStepper<WelcomeNavigationStep>
   
    private unowned let navigator: Navigator
  
    init(navigator: Navigator) {
        self.navigator = navigator
    }

    deinit {
        print("☑️ WelcomeViewModel deinit")
    }
}

extension WelcomeViewModel {
    func startApp() {
        navigator.step(.didStart)
    }
}
