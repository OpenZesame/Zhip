//
//  RestoreWalletUsingPrivateKeyScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI
import ZhipEngine
import enum Zesame.KeyRestoration
import enum Zesame.KDF
import struct Zesame.KDFParams
import struct Zesame.PrivateKey

// MARK: - BaseRestoreWalletViewModel
// MARK: -
protocol BaseRestoreWalletViewModel: ObservableObject {
    var canProceed: Bool { get set }
    var isRestoringWallet: Bool { get set }
    var keyRestoration: KeyRestoration? { get }
    func restore() async
}

extension BaseRestoreWalletViewModel {
    
    var kdfParams: KDFParams {
        #if DEBUG
        return .unsafeFast
        #else
        return .default
        #endif
    }
    
    var kdf: KDF {
        #if DEBUG
        return .pbkdf2
        #else
        return .scrypt
        #endif
    }
}

enum RestoreWalletUsingPrivateKeyNavigationStep {
    case userDidRestoreWallet(Wallet)
    case failedToRestoreWallet(error: Error)
}

// MARK: - RestoreWalletUsingPrivateKeyViewModel
// MARK: -
protocol RestoreWalletUsingPrivateKeyViewModel: BaseRestoreWalletViewModel {
    var privateKey: String { get set }
    var password: String { get set }
    var passwordConfirmation: String { get set }
//    var canProceed: Bool { get set }
//    var isRestoringWallet: Bool { get set }
//    func restore() async
}

extension RestoreWalletUsingPrivateKeyViewModel {
//    typealias Navigator = NavigationStepper<RestoreWalletUsingPrivateKeyNavigationStep>
    typealias Navigator = RestoreWalletViewModel.Navigator
}

// MARK: - DefaultRestoreWalletUsingPrivateKeyViewModel
// MARK: -
final class DefaultRestoreWalletUsingPrivateKeyViewModel: RestoreWalletUsingPrivateKeyViewModel {
    
    
    @Published var privateKey: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""
    @Published var canProceed: Bool = false
    @Published var isRestoringWallet: Bool = false
    
    private unowned let navigator: Navigator
    private let useCase: WalletUseCase
    
    init(navigator: Navigator, useCase: WalletUseCase) {
        self.navigator = navigator
        self.useCase = useCase
    }
    
    deinit {
        print("☑️ DefaultRestoreWalletUsingPrivateKeyViewModel deinit")
    }
}

// MARK: - RestoreWalletUsingPrivateKeyViewModel
// MARK: -
extension DefaultRestoreWalletUsingPrivateKeyViewModel {
    
    var keyRestoration: KeyRestoration? {
        guard let privateKey = PrivateKey(hex: self.privateKey) else {
            return nil
        }

        return KeyRestoration.privateKey(
            privateKey,
            encryptBy: password,
            kdf: kdf,
            kdfParams: kdfParams
        )
    }
    
    func restore() async {
        precondition(password == passwordConfirmation)
        guard let keyRestoration = keyRestoration else {
            print("⚠️ No key restoration, invalid private key hex?")
            return
        }
        isRestoringWallet = true
        do {
            let wallet = try await useCase.restoreWallet(name: "Wallet", from: keyRestoration)
            Task { @MainActor [unowned self] in
                isRestoringWallet = false
                navigator.step(.restoreWallet(wallet))
            }
        } catch {
            Task { @MainActor [unowned self] in
                isRestoringWallet = false
                navigator.step(.failedToRestoreWallet(error: error))
            }
        }
    }
}

// MARK: - RestoreWalletUsingPrivateKeyScreen
// MARK: -
struct RestoreWalletUsingPrivateKeyScreen<ViewModel: RestoreWalletUsingPrivateKeyViewModel>: View {
    @ObservedObject var viewModel: ViewModel
}

// MARK: - View
// MARK: -
extension RestoreWalletUsingPrivateKeyScreen {
    var body: some View {
        ForceFullScreen {
            VStack(spacing: 20) {
                InputField.privateKey(text: $viewModel.privateKey)
                PasswordInputFields(
                    password: $viewModel.password,
                    passwordConfirmation: $viewModel.passwordConfirmation
                )
                
                Button("Restore") {
                    Task {
                        await viewModel.restore()
                    }
                }
                .buttonStyle(.primary)
                .enabled(if: viewModel.canProceed)
                
            }.disableAutocorrection(true)
        }
    }
}

extension InputField {
    static func privateKey(
        prompt: String = "Private Key",
        text: Binding<String>
    ) -> Self {
        Self(
            prompt: prompt,
            text: text,
            isSecure: true,
            maxLength: 66, // "0x" + 64 hex private key chars => max length 66.
            characterRestriction: .onlyContains(whitelisted: .hexadecimalDigitsIncluding0x),
            validationRules: [
                ValidateInputRequirement.maximumLength(of: 64)
            ]
        )
    }
}
