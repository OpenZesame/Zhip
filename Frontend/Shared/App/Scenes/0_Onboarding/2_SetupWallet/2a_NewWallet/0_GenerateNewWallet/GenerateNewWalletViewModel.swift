//
//  GenerateNewWalletViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation

protocol GenerateNewWalletViewModel: ObservableObject {
    func `continue`() async
    var userHasConfirmedBackingUpPassword: Bool { get set }
    var isFinished: Bool { get }
    var password: String { get set }
    var passwordConfirmation: String { get set }
    var isGeneratingWallet: Bool { get set }
}
