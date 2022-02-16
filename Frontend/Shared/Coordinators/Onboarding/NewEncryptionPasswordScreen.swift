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
}

struct TextFieldValidation {
    let errorMessage: (String) -> String
    let validIf: (String) -> Bool
}

import Combine
final class DefaultNewEncryptionPasswordViewModel: NewEncryptionPasswordViewModel {
    
    private unowned let coordinator: NewWalletCoordinator
    private let walletUseCase: WalletUseCase
    @Published var userHasConfirmedBackingUpPassword = false
    @Published var password = ""
    @Published var passwordConfirmation = ""
    @Published var isFinished = false
        
    private var cancellables = Set<AnyCancellable>()
    
    init(
        coordinator: NewWalletCoordinator,
        useCase walletUseCase: WalletUseCase
    ) {
        self.coordinator = coordinator
        self.walletUseCase = walletUseCase
        
        canProceedPublisher
              .receive(on: RunLoop.main)
              .assign(to: \.isFinished, on: self)
              .store(in: &cancellables)
    }
    
    func `continue`() {
        coordinator.encryptionPasswordIsSet()
    }
    
    private var arePasswordsEqualPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $passwordConfirmation)
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map { password, passwordConfirmation in
                return password == passwordConfirmation
            }
            .eraseToAnyPublisher()
    }
    
    private var canProceedPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(arePasswordsEqualPublisher, $userHasConfirmedBackingUpPassword)
            .map { validPassword, userHasConfirmedBackingUpPassword in
                return validPassword && userHasConfirmedBackingUpPassword
            }
            .eraseToAnyPublisher()
    }
}

struct NewEncryptionPasswordScreen<ViewModel: NewEncryptionPasswordViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        ForceFullScreen {
            VStack(spacing: 40) {
                
                Labels(
                    title: "Set an encryption password",
                    subtitle: "Your encryption password is used to encrypt your private key. Make sure to back up your encryption password before proceeding."
                )
                
                VStack(spacing: 20) {
                    InputField(
                        prompt: "Encryption password",
                        text: $viewModel.password,
                        isSecure: true,
                        validationRules: [.minimumLength(of: 8)]
                    )
                    
                    InputField(
                        prompt: "Confirm encryption password",
                        text: $viewModel.passwordConfirmation,
                        isSecure: true,
                        validationRules: [
                            Validation { confirmText in
                                if confirmText != viewModel.password {
                                    return "Passwords does not match."
                                }
                                return nil // Valid
                            }
                        ]
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
    


struct InputField: View {
    
    var prompt: String = ""
    @Binding var text: String
    var isSecure: Bool = false
    var validationRules: [ValidationRule] = []
    
    var body: some View {
        HoverPromptTextField(
            prompt: prompt,
            text: $text,
            config: .init(
                isSecure: isSecure,
                behaviour: .init(
                    validation: .init(
                        rules: validationRules
                    )
                ),
                appearance: .init(
                    colors: .init(
                        defaultColors: .init(
                            neutral: .asphaltGrey,
                            valid: .teal,
                            invalid: .bloodRed
                        )
                    ),
                    fonts: .init(field: Font.zhip.title, prompt: Font.zhip.hint)
                )
            ),
            leftView: { params in
                Circle()
                    .fill(params.isEmpty ? params.colors.neutral : (params.isValid ? params.colors.valid : params.colors.invalid))
                    .frame(width: 16, height: 16)
            },
            rightView: { params in
                Group {
                if params.isSecureTextField && !params.isEmpty {
                    Button(action: {
                        withAnimation {
                            params.isRevealingSecrets.wrappedValue.toggle()
                        }
                    }) {
                        
                        Image(systemName: params.isRevealingSecrets.wrappedValue ? "eye.slash" : "eye").foregroundColor(params.isRevealingSecrets.wrappedValue ? Color.mellowYellow : Color.white)
                    }
                } else {
                    EmptyView()
                }
                }
            }
        )
    }
}
