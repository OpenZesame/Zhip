//
//  NewPINCodeViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-20.
//

import Foundation
import ZhipEngine

protocol NewPINCodeViewModel: ObservableObject {
    func skip()
    var pinCode: Pincode? { get set }
    var canProceed: Bool { get }
    func doneSettingPIN()
    
}

final class DefaultNewPINCodeViewModel: NewPINCodeViewModel {
    @Published var pinCode: Pincode?
}

extension DefaultNewPINCodeViewModel {
    func skip() {
        fatalError("skip")
    }
    
    var canProceed: Bool { pinCode != nil }
    
    func doneSettingPIN() {
        precondition(pinCode != nil)
    }
}
