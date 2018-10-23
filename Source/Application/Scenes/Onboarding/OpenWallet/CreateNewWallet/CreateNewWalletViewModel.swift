//
//  CreateNewWalletViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FormValidatorSwift
import Zesame

final class CreateNewWalletViewModel {

    private let bag = DisposeBag()

    private weak var navigator: CreateNewWalletNavigator?

    private let useCase: ChooseWalletUseCase

    init(navigator: CreateNewWalletNavigator, useCase: ChooseWalletUseCase) {

        self.navigator = navigator
        self.useCase = useCase

    }
}

extension CreateNewWalletViewModel: ViewModelType {

    struct Input {}

    struct Output {
        let wallet: Driver<Wallet>
    }

    func transform(input: Input) -> Output {

        let wallet = useCase.createNewWallet()

        return Output(
            wallet: wallet.asDriverOnErrorReturnEmpty()
        )
    }

}
