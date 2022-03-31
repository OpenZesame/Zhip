////
////  NewPINCodeViewModel.swift
////  Zhip
////
////  Created by Alexander Cyon on 2022-02-22.
////
//
//import Foundation
//import ZhipEngine
//import PINCode
//
//// MARK: - NewPINCodeNavigationStep
//// MARK: -
//public enum NewPINCodeNavigationStep {
//    case skipSettingPin
//    case setPIN(Pincode)
//}
//
//// MARK: - NewPINCodeViewModel
//// MARK: -
//public final class NewPINCodeViewModel: ObservableObject {
//   
//    @Published var pinCode: Pincode?
//    @Published var pinFieldText: String = ""
//
//    private let useCase: PINCodeUseCase
//    private unowned let navigator: Navigator
//    
//    public init(
//        navigator: Navigator,
//        useCase: PINCodeUseCase
//    ) {
//        self.useCase = useCase
//        self.navigator = navigator
//    }
//    
//    deinit {
//        print("☑️ NewPINCodeViewModel deinit")
//    }
//}
//
//// MARK: - Public
//// MARK: -
//public extension NewPINCodeViewModel {
//    
//    typealias Navigator = NavigationStepper<NewPINCodeNavigationStep>
//    
//    var canProceed: Bool { pinCode != nil }
//
//    func skip() {
//        useCase.skipSettingUpPincode()
//        navigator.step(.skipSettingPin)
//    }
//    
//    func doneSettingPIN() {
//        guard let pinCode = pinCode else {
//            print("UI bug, pinCode should not be nil according to view model logic, but UI incorrectly allowed calling this function: \(#function)")
//            return
//        }
//        navigator.step(.setPIN(pinCode))
//    }
//}
//
