//
//  UnlockAppWithPINScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-26.
//

import SwiftUI
import ZhipEngine

// MARK: - NewPINCodeNavigationStep
// MARK: -
public enum UnlockAppWithPINNavigationStep {
    case enteredCorrectPINCode
    case cancel
}

// MARK: - UnlockAppWithPINViewModel
// MARK: -
public final class UnlockAppWithPINViewModel: ObservableObject {
    public enum Mode {
        case enterToUnlocKApp
        case enterToRemovePIN
    }
   
    @Published var pinCode: Pincode?
    @Published var pinFieldText: String = ""

    private let useCase: PINCodeUseCase
    private unowned let navigator: Navigator
    let mode: Mode
    private let expectedPINCode: Pincode
    
    public init(
        mode: Mode = .enterToUnlocKApp,
        navigator: Navigator,
        useCase: PINCodeUseCase
    ) {
        guard let expectedPINCode = useCase.pincodeSubject.value else {
            fatalError("Cannot show 'UnlockAppWithPIN' since no PIN is set.")
        }
        self.expectedPINCode = expectedPINCode
        self.mode = mode
        self.useCase = useCase
        self.navigator = navigator
    }
    
    deinit {
        print("☑️ UnlockAppWithPINViewModel deinit")
    }
}

// MARK: - Public
// MARK: -
public extension UnlockAppWithPINViewModel {
    
    typealias Navigator = NavigationStepper<UnlockAppWithPINNavigationStep>
    
    var canProceed: Bool {
        guard
            let pinCode = pinCode,
            pinCode == expectedPINCode
        else {
            return false
        }
        return true
    }

    func cancel() {
        precondition(mode == .enterToRemovePIN)
        navigator.step(.cancel)
    }
    
    func proceed() {
        guard canProceed else {
            print("UI bug, pinCode should not be nil and must sequal expected according to view model logic, but UI incorrectly allowed calling this function: \(#function)")
            return
        }
        if mode == .enterToRemovePIN {
            useCase.deletePincode()
        }
        navigator.step(.enteredCorrectPINCode)
    }
}



// MARK: - UnlockAppWithPINScreen
// MARK: -
struct UnlockAppWithPINScreen: View {
    @ObservedObject var viewModel: UnlockAppWithPINViewModel
}

// MARK: - View
// MARK: -
extension UnlockAppWithPINScreen {
    var body: some View {
        ForceFullScreen {
            VStack {
                PINField(text: $viewModel.pinFieldText, pinCode: $viewModel.pinCode)
                
                Text("The app PIN is an extra safety measure used only to unlock the app. It is not used to encrypt your private key. Before setting a PIN, back up the wallet, otherwise you might get locked out of your wallet if you forget the PIN.")
                    .font(.zhip.body).foregroundColor(.silverGrey)

                Button(viewModel.mode == .enterToUnlocKApp ? "Unlock app" : "Remove PIN") {
                    viewModel.proceed()
                }
                .buttonStyle(.primary)
                .enabled(if: viewModel.canProceed)
            }
            .navigationTitle(viewModel.mode == .enterToUnlocKApp ? "Unlock app" : "Remove PIN")
            .toolbar {
                if viewModel.mode == .enterToRemovePIN {
                    Button("Cancel") {
                        viewModel.cancel()
                    }
                }
            }
        }
        
    }
}
