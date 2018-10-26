//
//  CreateNewWalletCoordinator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import Zesame

import RxSwift
import RxCocoa

final class CreateNewWalletCoordinator {
    let bag = DisposeBag()
    weak var presenter: Presenter?
    private weak var navigator: ChooseWalletNavigator?
    private let useCase: ChooseWalletUseCase

    init(navigationController: UINavigationController?, navigator: ChooseWalletNavigator, useCase: ChooseWalletUseCase) {
        self.presenter = navigationController
        self.navigator = navigator
        self.useCase = useCase
    }
}

extension CreateNewWalletCoordinator: AnyCoordinator {
    func start() {
        toCreateWallet()
    }
}

extension CreateNewWalletCoordinator: SteppingCoordinator {}

protocol SteppingCoordinator: AnyObject {
    var presenter: Presenter? { get }
    var bag: DisposeBag { get }

}

extension SteppingCoordinator {
    func navigateAndListen<V>(to sceneType: Scene<V>.Type, viewModel: V.ViewModel, presentation: PresentationMode = .animatedPush, navigationHandler: @escaping (V.ViewModel.Step) -> Void)
        where
        V: ScrollingStackView & ViewModelled,
        V.ViewModel: SteppingViewModel
    {
        let scene = Scene<V>.init(viewModel: viewModel)
        presenter?.present(scene, presentation: presentation)

        bag <~ viewModel.stepper.navigation.do(onNext: {
            navigationHandler($0)
        }).drive()
    }
}

protocol SteppingViewModel {
    associatedtype Step
    var stepper: Stepper<Step> { get }
}

// MARK: Navigation
private extension CreateNewWalletCoordinator {

    func toMain(wallet: Wallet) {
        navigator?.toMain(wallet: wallet)
    }

    func toBackupWallet(wallet: Wallet) {
        navigateAndListen(
            to: BackupWallet.self,
            viewModel: BackupWalletViewModel(wallet: wallet)
        ) { [weak self] in
            switch $0 {
            case .didBackup(let wallet): self?.toMain(wallet: wallet)
            }
        }
    }

    func toCreateWallet() {
        navigateAndListen(
            to: CreateNewWallet.self,
            viewModel: CreateNewWalletViewModel(useCase: useCase)
        ) { [weak self] in
            switch $0 {
            case .didCreateNew(let wallet): self?.toBackupWallet(wallet: wallet)
            }
        }
    }
}
