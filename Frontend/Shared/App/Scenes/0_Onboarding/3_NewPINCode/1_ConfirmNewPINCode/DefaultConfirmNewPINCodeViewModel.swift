//
//  DefaultConfirmNewPINCodeViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-22.
//

import Foundation
import ZhipEngine
import Combine

final class DefaultConfirmNewPINCodeViewModel: ConfirmNewPINCodeViewModel {
    
    private let expectedPIN: Pincode
    
    var pinMatchesExpected: Bool = false
    @Published var pinCode: Pincode? = nil
    @Published var pinFieldText: String = ""
    @Published var pinsDoNotMatchErrorMessage: String? = nil
    @Published var userHasConfirmedBackingUpPIN: Bool = false
    
    /// If user can proceed
    @Published var isFinished: Bool = false
    
    private unowned let navigator: Navigator
    private let useCase: PINCodeUseCase
    private var cancellables = Set<AnyCancellable>()
    
    let errorDurationInSeconds = 2
    
    init(
        navigator: Navigator,
        expectedPIN: Pincode,
        useCase: PINCodeUseCase
    ) {
        self.useCase = useCase
        self.navigator = navigator
        self.expectedPIN = expectedPIN
            
        subscribeToPublishers()
    }
    
    deinit {
        print("☑️ DefaultConfirmNewPINCodeViewModel deinit")
    }
    
}

extension DefaultConfirmNewPINCodeViewModel {
    func `continue`() {
        precondition(pinCode != nil)
        precondition(pinCode! == expectedPIN)
        
        useCase.userChoose(pincode: expectedPIN)
        navigator.step(.confirmed)
    }
    
    func skipSettingAnyPIN() {
        useCase.skipSettingUpPincode()
        navigator.step(.skipSettingPin)
    }
}

private extension DefaultConfirmNewPINCodeViewModel {
    
    func subscribeToPublishers() {
        
        errorMessagePublisher
            .receive(on: RunLoop.main)
            .assign(to: \.pinsDoNotMatchErrorMessage, on: self)
            .store(in: &cancellables)
        
        // Set error message to nil after a delay of `errorDuration`
        // after having received an errorm message
        errorMessagePublisher.filter { $0 != nil }
        .delay(for: .seconds(errorDurationInSeconds), scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { [unowned self] _ in
                pinsDoNotMatchErrorMessage = nil
                pinFieldText = "" // this SHOULD nil pinCode as well (internal logic of PINField)
            }
            .store(in: &cancellables)

        canProceedPublisher
              .receive(on: RunLoop.main)
              .assign(to: \.isFinished, on: self)
              .store(in: &cancellables)
    }
    
    var arePINCodesEqualPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(Just(expectedPIN), $pinCode)
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map { expectedPIN, pinConfirmation in
                return expectedPIN == pinConfirmation
            }
            .eraseToAnyPublisher()
    }
    
    var errorMessagePublisher: AnyPublisher<String?, Never> {
        Publishers.CombineLatest(Just(expectedPIN), $pinCode.compactMap { $0 })
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map { expectedPIN, pinConfirmation in
                return expectedPIN == pinConfirmation
            }
            .removeDuplicates()
            .map { pinsAreEqual in
                if pinsAreEqual {
                    return nil
                } else {
                    return "Pins do not match"
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var canProceedPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(arePINCodesEqualPublisher, $userHasConfirmedBackingUpPIN)
            .map { validPIN, userHasConfirmedBackingUpPIN in
                return validPIN && userHasConfirmedBackingUpPIN
            }
            .eraseToAnyPublisher()
    }
}
