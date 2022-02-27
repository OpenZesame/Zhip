//
//  UnlockAppWithPINViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-26.
//

import SwiftUI
import ZhipEngine
import Combine

// MARK: - NewPINCodeNavigationStep
// MARK: -
public enum UnlockAppWithPINNavigationStep {
    case enteredCorrectPINCode(intent: UnlockAppWithPINViewModel.UserIntent)
    case cancel
}

// MARK: - UnlockAppWithPINViewModel
// MARK: -
public final class UnlockAppWithPINViewModel: ObservableObject {
    public enum UserIntent {
        case enterToUnlockApp
        case enterToRemovePIN
        case enterToRemoveWallet
    }
   
    @Published var pinCode: Pincode?
    @Published var pinFieldText: String = ""

    private let useCase: PINCodeUseCase
    private unowned let navigator: Navigator
    let userIntent: UserIntent
    private let expectedPINCode: Pincode
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(
        userIntent: UserIntent = .enterToUnlockApp,
        navigator: Navigator,
        useCase: PINCodeUseCase
    ) {
        guard let expectedPINCode = useCase.pincodeSubject.value else {
            fatalError("Cannot show 'UnlockAppWithPIN' since no PIN is set.")
        }
        self.expectedPINCode = expectedPINCode
        self.userIntent = userIntent
        self.useCase = useCase
        self.navigator = navigator
        
        subscribeToPublishers()
    }
    
    deinit {
        print("☑️ UnlockAppWithPINViewModel deinit")
    }
}

// MARK: - Public
// MARK: -
public extension UnlockAppWithPINViewModel {
    
    typealias Navigator = NavigationStepper<UnlockAppWithPINNavigationStep>
    
    var isUserAllowedToCancel: Bool {
        switch userIntent {
        case .enterToUnlockApp:
            return false
        case .enterToRemovePIN, .enterToRemoveWallet:
            return true
        }
    }
    
    var proceedButtonTitle: String {
        switch userIntent {
        case .enterToUnlockApp:
            return "Unlock app"
        case .enterToRemovePIN:
            return "Remove PIN"
        case .enterToRemoveWallet:
            return "Remove wallet"
        }
    }
    
    var navigationTitle: String {
        proceedButtonTitle
    }

    func cancel() {
        precondition(userIntent == .enterToRemovePIN)
        navigator.step(.cancel)
    }
    
    
    func subscribeToPublishers() {
        $pinCode.filter { [unowned self] enteredPin in
            enteredPin == expectedPINCode
        }.mapToVoid()
        .sink(receiveValue: { [unowned self] in
            navigator.step(.enteredCorrectPINCode(intent: userIntent))
        }).store(in: &cancellables)
    }
}

extension Publisher {
    func mapToVoid() -> AnyPublisher<Void, Failure> {
        map { _ in }.eraseToAnyPublisher()
    }
}
