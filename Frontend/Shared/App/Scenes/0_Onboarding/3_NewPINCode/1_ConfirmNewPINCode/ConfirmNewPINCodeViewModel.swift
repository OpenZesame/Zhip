//
//  ConfirmNewPINCodeViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-22.
//

import Foundation
import ZhipEngine
import Combine

enum ConfirmNewPINCodeNavigationStep {
    case skipSettingPin
    case confirmed
}

protocol ConfirmNewPINCodeViewModel: ObservableObject {
    var pinCode: Pincode? { get set }
    var pinFieldText: String { get set }
    var pinsDoNotMatchErrorMessage: String? { get set }
    var pinMatchesExpected: Bool { get }
    var userHasConfirmedBackingUpPIN: Bool { get set }
    
    /// If user can proceed
    var isFinished: Bool { get }
    
    func skipSettingAnyPIN()
    func `continue`()
}

extension ConfirmNewPINCodeViewModel {
    typealias Navigator = PassthroughSubject<ConfirmNewPINCodeNavigationStep, Never>
}
