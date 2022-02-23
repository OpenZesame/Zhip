//
//  DefaultWelcomeViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import Foundation

final class DefaultWelcomeViewModel: WelcomeViewModel {
   
    private unowned let navigator: Navigator
  
    init(navigator: Navigator) {
        self.navigator = navigator
    }

    deinit {
        print("☑️ DefaultWelcomeViewModel deinit")
    }
}

extension DefaultWelcomeViewModel {
    func startApp() {
        navigator.step(.didStart)
    }
}
