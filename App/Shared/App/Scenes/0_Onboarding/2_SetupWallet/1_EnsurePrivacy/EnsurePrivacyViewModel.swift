//
//  EnsurePrivacyViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation

// MARK: - EnsurePrivacyNavigationStep
// MARK: -
public enum EnsurePrivacyNavigationStep {
    case thinkScreenMightBeWatched
    case ensurePrivacy
}

// MARK: - EnsurePrivacyViewModel
// MARK: -
public final class EnsurePrivacyViewModel: ObservableObject {
    
    private unowned let navigator: Navigator
    
    public init(navigator: Navigator) {
        self.navigator = navigator
    }
    
    deinit {
        print("☑️ EnsurePrivacyViewModel deinit")
    }
}

// MARK: - Public
// MARK: -
public extension EnsurePrivacyViewModel {

    typealias Navigator = NavigationStepper<EnsurePrivacyNavigationStep>
    
    func privacyIsEnsured() {
        navigator.step(.ensurePrivacy)
    }
    
    func myScreenMightBeWatched() {
        navigator.step(.thinkScreenMightBeWatched)
    }
}
