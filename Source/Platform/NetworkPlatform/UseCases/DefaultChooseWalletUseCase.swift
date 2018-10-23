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

    func createNewWallet(encryptionPassphrase: String) -> Observable<Wallet> {
        return zilliqaService.createNewWallet(encryptionPassphrase: encryptionPassphrase)
    }

    func restoreWallet(from restoration: KeyRestoration) -> Observable<Wallet> {
        return zilliqaService.restoreWallet(from: restoration)
    }

}
