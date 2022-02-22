//
//  DefaultNewPINCodeViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-22.
//

import Foundation
import ZhipEngine

final class DefaultNewPINCodeViewModel: NewPINCodeViewModel {
    @Published var pinCode: Pincode?
    private unowned let navigator: Navigator
    @Published var pinFieldText: String = ""
    init(navigator: Navigator) {
        self.navigator = navigator
        print("DefaultNewPINCodeViewModel init")
    }
    
    
    deinit {
        print("DefaultNewPINCodeViewModel deinit")
    }
}

extension DefaultNewPINCodeViewModel {
    var canProceed: Bool { pinCode != nil }

    func skip() {
        navigator.step(.skipSettingPin)
    }
    
    func doneSettingPIN() {
        guard let pinCode = pinCode else {
            print("UI bug, pinCode should not be nil according to view model logic, but UI incorrectly allowed calling this function: \(#function)")
            return
        }
        navigator.step(.setPIN(pinCode))
    }
}

