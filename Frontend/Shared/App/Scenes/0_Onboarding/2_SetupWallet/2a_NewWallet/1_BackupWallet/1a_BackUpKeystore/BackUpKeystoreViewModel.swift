//
//  BackUpKeystoreViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-19.
//

import Foundation

enum BackUpKeystoreNavigationStep {
    case finishedBackingUpKeystore
}

protocol BackUpKeystoreViewModel: ObservableObject {
    func doneBackingUpKeystore()
    func copyKeystoreToPasteboard()
    var isPresentingDidCopyKeystoreAlert: Bool { get set }
    var displayableKeystore: String { get }
}

extension BackUpKeystoreViewModel {
    typealias Navigator = NavigationStepper<BackUpKeystoreNavigationStep>
}
