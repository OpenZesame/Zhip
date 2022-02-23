//
//  DefaultEnsurePrivacyViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation

final class DefaultEnsurePrivacyViewModel: EnsurePrivacyViewModel {
    
    private unowned let navigator: Navigator
    
    init(navigator: Navigator) {
        self.navigator = navigator
    }
    
    deinit {
        print("☑️ DefaultEnsurePrivacyViewModel deinit")
    }
}

// MARK: - EnsurePrivacyViewModel
// MARK: -
extension DefaultEnsurePrivacyViewModel {
    func privacyIsEnsured() {
        navigator.step(.ensurePrivacy)
    }
    
    func myScreenMightBeWatched() {
        navigator.step(.thinkScreenMightBeWatched)
    }
}
