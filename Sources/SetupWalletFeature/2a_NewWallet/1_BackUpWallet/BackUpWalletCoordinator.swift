////
////  BackUpWalletCoordinator.swift
////  Zhip
////
////  Created by Alexander Cyon on 2022-02-17.
////
//
//import SwiftUI
//import ZhipEngine
//import Stinsen
//import Wallet
//
//public enum BackUpWalletCoordinatorNavigationStep {
//    case userDidBackUpWallet(Wallet)
//}
//
//// MARK: - BackUpWalletCoordinator
//// MARK: -
//public final class BackUpWalletCoordinator: NavigationCoordinatable {
//    
//    public enum Mode {
//        case mandatoryBackUpPartOfOnboarding
//        case userInitiatedFromSettings
//    }
//    
//  
//    public let stack = NavigationStack<BackUpWalletCoordinator>(initial: \.backupWallet)
//    
//    @Root var backupWallet = makeBackUpWallet
//    @Route(.push) var revealKeystoreRoute = makeRevealKeystore
//    @Route(.push) var revealPrivateKeyRoute = makeBackUpRevealedKeyPair
//    
//    private let useCaseProvider: UseCaseProvider
//    private let wallet: Wallet
//    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
//    private unowned let navigator: Navigator
//    
//    private lazy var backUpKeyPairCoordinatorNavigator = BackUpKeyPairCoordinator.Navigator()
//    private lazy var backupWalletNavigator = BackUpWalletViewModel.Navigator()
//    private lazy var backUpKeystoreNavigator = BackUpKeystoreViewModel.Navigator()
//    
//    private let mode: Mode
//    
//    public init(
//        mode: Mode,
//        navigator: Navigator,
//        useCaseProvider: UseCaseProvider,
//        wallet: Wallet
//    ) {
//        self.mode = mode
//        self.navigator = navigator
//        self.useCaseProvider = useCaseProvider
//        self.wallet = wallet
//    }
//    
//    deinit {
//        print("✅ BackUpWalletCoordinator DEINIT 💣")
//    }
//    
//}
//
//// MARK: - NavigationCoordinatable
//// MARK: -
//public extension BackUpWalletCoordinator {
//    @ViewBuilder func customize(_ view: AnyView) -> some View {
//        view
//            .onReceive(backUpKeyPairCoordinatorNavigator) { [unowned self] userDid in
//                switch userDid {
//                case .failedToDecryptWallet(let error):
//                    failedToDecryptWallet(error: error)
//                case .finishedBackingUpKeys:
//                    finishedBackingUpKeys()
//                }
//            }
//            .onReceive(backupWalletNavigator) { [unowned self] userDid in
//                switch userDid {
//                case .revealKeystore:
//                    toRevealKeystore()
//                case .revealPrivateKey:
//                    toBackUpRevealedKeyPair()
//                case .finishedBackingUpWallet:
//                    doneBackingUpWallet()
//                }
//            }
//            .onReceive(backUpKeystoreNavigator) { [unowned self] userDid in
//                switch userDid {
//                case .finishedBackingUpKeystore:
//                    doneBackingUpKeystore()
//                }
//            }
//    
//    }
//}
//
//// MARK: - Public
//// MARK: -
//public extension BackUpWalletCoordinator {
//    typealias Navigator = NavigationStepper<BackUpWalletCoordinatorNavigationStep>
//    
//}
//
//// MARK: - Private
//// MARK: -
//private extension BackUpWalletCoordinator {
//    func failedToDecryptWallet(error: Swift.Error) {
//        fatalError("what to do? failedToDecryptWallet: \(error)")
//    }
//    
//    func finishedBackingUpKeys() {
//        self.popLast {
//            print("Pop private key")
//        }
//    }
//    
//    func revealKeystore() {
//        toRevealKeystore()
//    }
//    func revealPrivateKey() {
//        toBackUpRevealedKeyPair()
//    }
//    
//    func doneBackingUpWallet() {
//        navigator.step(.userDidBackUpWallet(wallet))
//    }
//    
//    func doneBackingUpKeystore() {
//        self.popLast {
//            print("Pop keystore")
//        }
//    }
//}
//
//// MARK: - Factory
//// MARK: -
//private extension BackUpWalletCoordinator {
//    
//    @ViewBuilder
//    func makeBackUpWallet() -> some View {
//        
//        let viewModel = BackUpWalletViewModel(
//            mode: mode,
//            navigator: backupWalletNavigator,
//            wallet: wallet
//        )
//        
//        BackUpWalletScreen(viewModel: viewModel)
//    }
//    
//    @ViewBuilder
//    func makeRevealKeystore() -> some View {
//        
//        let viewModel = BackUpKeystoreViewModel(
//            navigator: backUpKeystoreNavigator,
//            wallet: wallet
//        )
//        
//        BackUpKeystoreScreen(viewModel: viewModel)
//    }
//    
//    func makeBackUpRevealedKeyPair() -> NavigationViewCoordinator<BackUpKeyPairCoordinator> {
//        NavigationViewCoordinator(
//            BackUpKeyPairCoordinator(
//                navigator: backUpKeyPairCoordinatorNavigator,
//                useCase: walletUseCase,
//                wallet: wallet
//            )
//        )
//    }
//}
//   
//// MARK: - Routing
//// MARK: -
//private extension BackUpWalletCoordinator {
//    
//    func toRevealKeystore() {
//        route(to: \.revealKeystoreRoute)
//    }
//    
//    func toBackUpRevealedKeyPair() {
//        route(to: \.revealPrivateKeyRoute)
//    }
//}
