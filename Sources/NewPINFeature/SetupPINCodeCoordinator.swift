////
////  SetupPINCodeCoordinator.swift
////  Zhip
////
////  Created by Alexander Cyon on 2022-02-12.
////
//
//import SwiftUI
//import Stinsen
//import ZhipEngine
//import PIN
//
//enum SetupPINCoordinatorNavigationStep {
//    case finishedPINSetup
//}
//
//// MARK: - SetupPINCodeCoordinator
//// MARK: -
//final class SetupPINCodeCoordinator: NavigationCoordinatable {
//    
//    typealias Navigator = NavigationStepper<SetupPINCoordinatorNavigationStep>
//    
//    let stack = NavigationStack<SetupPINCodeCoordinator>(initial: \.newPIN)
//    @Root var newPIN = makeNewPIN
//    @Route(.push) var confirmPIN = makeConfirmPIN(expectedPIN:)
//    
//    private lazy var newPinNavigator = NewPINCodeViewModel.Navigator()
//    private lazy var confirmNewPinNavigator = ConfirmNewPINCodeViewModel.Navigator()
//    private unowned let navigator: Navigator
//    private let useCase: PINCodeUseCase
//    
//    init(navigator: Navigator, useCase: PINCodeUseCase) {
//        self.navigator = navigator
//        self.useCase = useCase
//    }
//    
//    deinit {
//        print("✅ SetupPINCodeCoordinator DEINIT 💣")
//    }
//}
//
//// MARK: - NavigationCoordinatable
//// MARK: -
//extension SetupPINCodeCoordinator {
//    @ViewBuilder func customize(_ view: AnyView) -> some View {
//        view
//            .onReceive(newPinNavigator) { [unowned self] userDid in
//                switch userDid {
//                case .setPIN(let newPin):
//                    self.route(to: \.confirmPIN, newPin)
//                case .skipSettingPin:
//                    skipSettingPin()
//                }
//            }
//            .onReceive(confirmNewPinNavigator) { [unowned self] userDid in
//                switch userDid {
//                case .skipSettingPin:
//                    skipSettingPin()
//                case .confirmed:
//                    finished()
//                }
//            }
//        
//    }
//}
//
//// MARK: - Routing
//// MARK: -
//extension SetupPINCodeCoordinator {
//    
//    func skipSettingPin() {
//        finished()
//    }
//    
//    func finished() {
//        navigator.step(.finishedPINSetup)
//    }
//}
//
//    
//// MARK: - Factory
//// MARK: -
//extension SetupPINCodeCoordinator {
//  
//    @ViewBuilder
//    func makeNewPIN() -> some View {
//        
//        let viewModel = NewPINCodeViewModel(
//            navigator: newPinNavigator,
//            useCase: useCase
//        )
//        
//        NewPINCodeScreen(viewModel: viewModel)
//    }
//    
//    @ViewBuilder
//    func makeConfirmPIN(expectedPIN: PIN) -> some View {
//        
//        let viewModel = ConfirmNewPINCodeViewModel(
//            navigator: confirmNewPinNavigator,
//            expectedPIN: expectedPIN,
//            useCase: useCase
//        )
//        
//        ConfirmNewPINCodeScreen(viewModel: viewModel)
//    }
//}
