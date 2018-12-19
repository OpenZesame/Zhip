//
//  ViewModelTestCase.swift
//  ZupremeTests
//
//  Created by Alexander Cyon on 2018-12-18.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import Zupreme

import RxSwift
import RxCocoa
import RxBlocking
import RxTest

import Zesame


protocol ViewModelSpecifier where ViewModel.Input.FromController == InputFromController {
    associatedtype ViewModel: ViewModelType
}

extension ViewModelSpecifier {
    typealias Input = ViewModel.Input
    typealias InputFromView = ViewModel.Input.FromView
    typealias Output = ViewModel.Output
}

// MARK: Helpers
protocol ViewModelTesting: AnyObject, ViewModelSpecifier {
    var scheduler: TestScheduler { get set }
    var viewModel: ViewModel! { get set }
    var cachedWallet: Zupreme.Wallet? { get set }

    var emptyInputFromView: InputFromView { get }
}

extension ViewModelTesting {

    func makeWallet(useCache: Bool = true, success: @escaping (Zupreme.Wallet) -> Void) {
        if useCache, let cached = cachedWallet {
            return success(cached)
        }

        let privateKey = PrivateKey(hex: "0507A445DAA5B543AB568BDBC8E9FBB167B45533DCEDEE0505B012677C86B3A0")!
        let passphrase = "apabanan"
        let address = Address(privateKey: privateKey)
        Keystore.from(address: address, privateKey: privateKey, encryptBy: passphrase) {
            guard case .success(let keystore) = $0 else {
                return XCTFail()
            }
            let _wallet = Zesame.Wallet(keystore: keystore, address: address)
            let wallet = Zupreme.Wallet(wallet: _wallet, origin: .imported)
            self.cachedWallet = wallet
            success(wallet)
        }
    }

    @discardableResult
    func transformEmptyInputToOutput() -> Output {
        XCTAssertNotNil(viewModel)
        return viewModel.transform(inputFromView: emptyInputFromView)
    }

    func assertDriverValues(assertions: @escaping (TestScheduler) -> Void) {
        let scheduler: TestScheduler = self.scheduler
        SharingScheduler.mock(scheduler: scheduler) {
            assertions(scheduler)
        }
    }
}
