//
//  EnsurePrivacyViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation

enum EnsurePrivacyNavigationStep {
    case thinkScreenMightBeWatched
    case ensurePrivacy
}

protocol EnsurePrivacyViewModel: ObservableObject {
    func privacyIsEnsured()
    func myScreenMightBeWatched()
}

extension EnsurePrivacyViewModel {
    typealias Navigator = NavigationStepper<EnsurePrivacyNavigationStep>
}
