//
//  ChooseWalletUseCase.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import RxSwift
import Zesame

protocol ChooseWalletUseCase {
    func createNewWallet() -> Observable<Wallet>
    func restoreWallet(from restoration: KeyRestoration) -> Observable<Wallet>
}
