//
//  BackUpWalletViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-19.
//

import SwiftUI
import Foundation
import Combine
import struct Zesame.Keystore
import ZhipEngine
import Wallet
import Common

// MARK: - BackUpWalletNavigationStep
// MARK: -
public enum BackUpWalletNavigationStep {
    case finishedBackingUpWallet
    case revealKeystore
    case revealPrivateKey
}


// MARK: - BackUpWalletViewModel
// MARK: -
public final class BackUpWalletViewModel: ObservableObject {
    
    
    @Published var userHasConfirmedBackingUpWallet: Bool
    @Published var isFinished = false
    @Published var isPresentingDidCopyKeystoreAlert = false
    private unowned let navigator: Navigator
    private let wallet: Wallet
    
    private var cancellables = Set<AnyCancellable>()
    public let mode: BackUpWalletCoordinator.Mode
    
    public init(
        mode: BackUpWalletCoordinator.Mode,
        navigator: Navigator,
        wallet: Wallet
    ) {
        self.mode = mode
        self.userHasConfirmedBackingUpWallet = mode == .userInitiatedFromSettings
        self.navigator = navigator
        self.wallet = wallet
        
        subscribeToPublishers()
    }
}

// MARK: - Public
// MARK: -
public extension BackUpWalletViewModel {
    
    typealias Navigator = NavigationStepper<BackUpWalletNavigationStep>
    

    func `continue`() {
        navigator.step(.finishedBackingUpWallet)
    }
    
    func copyKeystoreToPasteboard() {
        guard copyToPasteboard(contents: wallet.keystoreAsJSON) else { return }
        
        isPresentingDidCopyKeystoreAlert = true
    }
    
    func revealKeystore() {
        navigator.step(.revealKeystore)
    }
    
    func revealPrivateKey() {
        navigator.step(.revealPrivateKey)
    }
}

// MARK: - Private
// MARK: -
private extension BackUpWalletViewModel {
    func subscribeToPublishers() {
        // `userHasConfirmedBackingUpWallet` => `isFinished`
        $userHasConfirmedBackingUpWallet
            .assign(to: \.isFinished, on: self)
            .store(in: &cancellables)
        
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

// MARK: - Helpers
// MARK: - 
extension Wallet {
    var keystoreAsJSON: String {
        return keystore.asPrettyPrintedJSONString
    }
}

extension Keystore {
    var asPrettyPrintedJSONString: String {
        guard let keystoreJSON = try? JSONEncoder(outputFormatting: .prettyPrinted).encode(self) else {
            incorrectImplementation("should be able to JSON encode a keystore")
        }
        guard let jsonString = String(data: keystoreJSON, encoding: .utf8) else {
            incorrectImplementation("Should be able to create JSON string from Data")
        }
        return jsonString
    }
}

func copyToPasteboard(contents: String) -> Bool {
    #if os(iOS)
    UIPasteboard.general.string = contents
    return true
    #elseif os(macOS)
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(contents, forType: .string)
    return true
    #else
    print("Unsupported platform, cannot copy to pasteboard.")
    return false
    #endif
}
