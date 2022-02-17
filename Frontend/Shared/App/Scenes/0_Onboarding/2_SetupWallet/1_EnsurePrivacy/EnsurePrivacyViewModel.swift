//
//  EnsurePrivacyViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation

protocol EnsurePrivacyViewModel: ObservableObject {
    func privacyIsEnsured()
    func myScreenMightBeWatched()
}
