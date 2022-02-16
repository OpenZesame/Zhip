//
//  NewEncryptionPasswordScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-14.
//

import SwiftUI

protocol NewEncryptionPasswordViewModel: ObservableObject {
    func `continue`()
    var userHasConfirmedBackingUpPassword: Bool { get set }
    var isFinished: Bool { get }
    var password: String { get set }
    var passwordConfirmation: String { get set }
    var isPasswordValid: Bool { get set }
    var isConfirmPasswordValid: Bool { get set }
    var passwordValidation: TextFieldValidation { get }
    var confirmPasswordValidation: TextFieldValidation { get }
    
}

struct TextFieldValidation {
    let errorMessage: (String) -> String
    let validIf: (String) -> Bool
}

final class DefaultNewEncryptionPasswordViewModel: NewEncryptionPasswordViewModel {
    
    private unowned let coordinator: NewWalletCoordinator
    private let walletUseCase: WalletUseCase
    @Published var userHasConfirmedBackingUpPassword = false
    @Published var password = ""
    @Published var passwordConfirmation = ""
    @Published var isFinished = false
    
    @Published var isPasswordValid: Bool = false
    @Published var isConfirmPasswordValid = false
    let passwordValidation = TextFieldValidation(errorMessage: { _ in "Invalid password" }, validIf: { $0.count >= 8 })
    let confirmPasswordValidation = TextFieldValidation(errorMessage: { _ in "Password confirmation invalid" }, validIf: { $0.count >= 8 })
    
    init(
        coordinator: NewWalletCoordinator,
        useCase walletUseCase: WalletUseCase
    ) {
        self.coordinator = coordinator
        self.walletUseCase = walletUseCase
    }
    
    func `continue`() {
        coordinator.encryptionPasswordIsSet()
    }
    
}

struct NewEncryptionPasswordScreen<ViewModel: NewEncryptionPasswordViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    @State var DELETEME = ""
    var body: some View {
        ForceFullScreen {
            VStack(spacing: 40) {
                
                Labels(
                    title: "Set an encryption password",
                    subtitle: "Your encryption password is used to encrypt your private key. Make sure to back up your encryption password before proceeding."
                )
                
                VStack(spacing: 20) {
                    HoverPromptTextField(
                        prompt: "Encryption password",
                        text: $viewModel.password,
                        config: .init(
                            behaviour: .init(
                                validationTriggering: .lazyErrorEagerOK,
                                validation: .init(
                                    rules: [.minimumLength(of: 8)]
                                )
                            )
                        ),
                        leftView: makeLeftView
                    )
                    HoverPromptTextField(
                        prompt: "Confirm password",
                        text: $DELETEME,
                        config: .init(
                            isSecure: true,
                            behaviour: .init(
                                validationTriggering: .lazyErrorEagerOK,
                                validation: .init(
                                    rules: [.maximumLength(of: 6)]
                                )
                            )
                        ),
                        leftView: makeLeftView
                    )
                }
                
                Spacer()
                
                Toggle("I have securely backed up my encryption password", isOn: $viewModel.userHasConfirmedBackingUpPassword)                
                Button("Continue") {
                    viewModel.continue()
                }
                .buttonStyle(.primary)
                .disabled(!viewModel.isFinished)
            }
        }
    }
    
}

private extension NewEncryptionPasswordScreen {
    
    @ViewBuilder
    func makeLeftView(
        params: HoverPromptTextFieldExtraViewsParams
    ) -> some View {
        Circle()
            .fill(params.isEmpty ? params.colors.neutral : (params.isValid ? params.colors.valid : params.colors.invalid))
            .frame(width: 16, height: 16)
    }
    
}
