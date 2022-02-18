//
//  DecryptKeystoreToRevealKeyPairScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-18.
//

import SwiftUI
import ZhipEngine
import Combine

protocol DecryptKeystoreToRevealKeyPairViewModel: ObservableObject {
    var password: String { get set }
    var isDecrypting: Bool { get set }
    var isPasswordOnValidFormat: Bool { get set }
    func decrypt() async
}

final class DefaultDecryptKeystoreToRevealKeyPairViewModel<Coordinator: BackUpKeyPairCoordinator>: DecryptKeystoreToRevealKeyPairViewModel {
    
    @Published var password = ""
    @Published var isDecrypting = false
    @Published var isPasswordOnValidFormat = false
    
    private unowned let coordinator: Coordinator
    private let wallet: Wallet
    private let useCase: WalletUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: Coordinator, useCase: WalletUseCase, wallet: Wallet) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.wallet = wallet
        
    }

    func decrypt() async {
        precondition(isPasswordOnValidFormat)
        isDecrypting = true
        print("decrypting...")
        defer { isDecrypting = false }
        do {
            let keyPair = try await useCase.extractKeyPairFrom(
                keystore: wallet.keystore,
                encryptedBy: password
            )
            print("successfully decrypted")
            coordinator.didDecryptWallet(keyPair: keyPair)
        } catch {
            print("failed to decrypt")
            coordinator.failedToDecryptWallet(error: error)
        }
    }
}


struct DecryptKeystoreToRevealKeyPairScreen<ViewModel: DecryptKeystoreToRevealKeyPairViewModel>: View {
    @ObservedObject var viewModel: ViewModel
}

// MARK: - View
// MARK: -
extension DecryptKeystoreToRevealKeyPairScreen {
    var body: some View {
        ForceFullScreen {
            VStack {
                
                Text("Enter your encryption password to reveal your private and public key.")
                
                InputField(
                    prompt: "Encryption password",
                    text: $viewModel.password,
                    isValid: $viewModel.isPasswordOnValidFormat,
                    isSecure: true,
                    validationRules: .encryptionPassword
                )
                
                Spacer()
                
                Button("Reveal") {
                    Task { @MainActor in
                        await viewModel.decrypt()
                    }
                }
                .disabled(!viewModel.isPasswordOnValidFormat || viewModel.isDecrypting)
                .buttonStyle(.primary(isLoading: $viewModel.isDecrypting))
            }
        }
    }
}
