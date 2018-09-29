//
//  ChooseWalletUseCase.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import Zesame
import RxSwift

final class DefaultChooseWalletUseCase {
    private let zilliqaService: ZilliqaServiceReactive

    init(zilliqaService: ZilliqaServiceReactive) {
        self.zilliqaService = zilliqaService
    }
}

extension DefaultChooseWalletUseCase: ChooseWalletUseCase {

    func createNewWallet() -> Observable<Wallet> {
        return zilliqaService.createNewWallet()
    }

    func restoreWallet(from restoration: KeyRestoration) -> Observable<Wallet> {
        switch restoration {
        case .privateKey(let hexString):
            return Observable.from(
                optional: Wallet(privateKeyHex: hexString)
            )
        }
    }

}
