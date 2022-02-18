//
//  BackUpRevealedKeyPairScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI
import Zesame
import Combine

protocol BackUpRevealedKeyPairViewModel: ObservableObject {
    var displayablePrivateKey: String { get }
    var displayablePublicKey: String { get }
    func copyPrivateKeyToPasteboard()
    func copyPublicKeyToPasteboard()
    var isPresentingDidCopyToPasteboardAlert: Bool { get set }
    func doneBackingUpKeys()
}

final class DefaultBackUpRevealedKeyPairViewModel<Coordinator: BackUpKeyPairCoordinator>: BackUpRevealedKeyPairViewModel {
    
    @Published var isPresentingDidCopyToPasteboardAlert = false
    private unowned let coordinator: Coordinator
    private let keyPair: KeyPair
    
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: Coordinator, keyPair: KeyPair) {
        self.coordinator = coordinator
        self.keyPair = keyPair
        
        // Autoclose `Did Copy Keystore` Alert after delay
        $isPresentingDidCopyToPasteboardAlert
        .filter { isPresenting in
            isPresenting
        }
        .delay(for: 2, scheduler: RunLoop.main) // dismiss after delay
        .map { _ in false } // `isPresentingDidCopyKeystoreAlert = false`
        .assign(to: \.isPresentingDidCopyToPasteboardAlert, on: self)
        .store(in: &cancellables)
    }
}

extension DefaultBackUpRevealedKeyPairViewModel {
    var displayablePrivateKey: String {
        keyPair.privateKey.asHex().lowercased()
    }
    
    var displayablePublicKey: String {
        keyPair.publicKey.hex.uncompressed.lowercased()
    }
    
    func copyPrivateKeyToPasteboard() {
        guard copyToPasteboard(contents: displayablePrivateKey) else {
            return
        }
        isPresentingDidCopyToPasteboardAlert = true
    }
    
    func copyPublicKeyToPasteboard() {
        guard copyToPasteboard(contents: displayablePublicKey) else {
            return
        }
        isPresentingDidCopyToPasteboardAlert = true
    }
    
    func doneBackingUpKeys() {
        coordinator.doneBackingUpKeys()
    }
}

struct BackUpRevealedKeyPairScreen<ViewModel: BackUpRevealedKeyPairViewModel>: View {
    @ObservedObject var viewModel: ViewModel
}


// MARK: - View
// MARK: -
extension BackUpRevealedKeyPairScreen {
    var body: some View {
        ForceFullScreen {
            VStack(alignment: .leading, spacing: 16) {
                Text("Private key")
                    .font(.zhip.title)
                    .foregroundColor(.white)
                
                Text("\(viewModel.displayablePrivateKey)")
                    .font(.zhip.body)
                    .textSelection(.enabled)
                    .foregroundColor(.white)
                
                Button("Copy") {
                    viewModel.copyPrivateKeyToPasteboard()
                }
                .buttonStyle(.hollow)
                
                Text("Public key (Uncompressed)")
                    .font(.zhip.title)
                    .foregroundColor(.white)
                
                Text("\(viewModel.displayablePublicKey)")
                    .font(.zhip.body)
                    .textSelection(.enabled)
                    .foregroundColor(.white)
                
                Button("Copy") {
                    viewModel.copyPublicKeyToPasteboard()
                }
                .buttonStyle(.hollow)
                
                Spacer()
            }
            .alert(isPresented: $viewModel.isPresentingDidCopyToPasteboardAlert) {
                Alert(
                    title: Text("Copied to pasteboard."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationTitle("Back up keys")
        .toolbar {
            Button("Done") {
                viewModel.doneBackingUpKeys()
            }
        }
    }
}
