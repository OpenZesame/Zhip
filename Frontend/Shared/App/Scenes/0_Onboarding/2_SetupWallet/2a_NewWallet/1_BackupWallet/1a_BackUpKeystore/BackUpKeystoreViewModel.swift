//
//  BackUpKeystoreViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-19.
//

import Foundation
import ZhipEngine
import Combine

// MARK: - BackUpKeystoreNavigationStep
// MARK: -
public enum BackUpKeystoreNavigationStep {
    case finishedBackingUpKeystore
}

// MARK: - BackUpKeystoreViewModel
// MARK: -
public final class BackUpKeystoreViewModel: ObservableObject {
    
    private unowned let navigator: Navigator
    private let wallet: Wallet
    
    @Published var isPresentingDidCopyKeystoreAlert = false
    private var cancellables = Set<AnyCancellable>()
    
    public init(navigator: Navigator, wallet: Wallet) {
        self.navigator = navigator
        self.wallet = wallet
        
        // Autoclose `Did Copy Keystore` Alert after delay
        $isPresentingDidCopyKeystoreAlert
            .filter { isPresenting in
                isPresenting
            }
            .delay(for: 2, scheduler: RunLoop.main) // dismiss after delay
            .map { _ in false } // `isPresentingDidCopyKeystoreAlert = false`
            .assign(to: \.isPresentingDidCopyKeystoreAlert, on: self)
            .store(in: &cancellables)
    }
}

// MARK: - Public
// MARK: -
public extension BackUpKeystoreViewModel {
    
    typealias Navigator = NavigationStepper<BackUpKeystoreNavigationStep>
    
    func doneBackingUpKeystore() {
        navigator.step(.finishedBackingUpKeystore)
    }
    
    var displayableKeystore: String {
        wallet.keystoreAsJSON
    }
    
    func copyKeystoreToPasteboard() {
        guard copyToPasteboard(contents: displayableKeystore) else { return }
        
        isPresentingDidCopyKeystoreAlert = true
    }
}
