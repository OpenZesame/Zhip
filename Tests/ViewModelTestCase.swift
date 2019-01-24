//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import UIKit
import XCTest
@testable import Zhip

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
    var cachedWallet: Zhip.Wallet? { get set }

    var emptyInputFromView: InputFromView { get }
}

extension ViewModelTesting {

    func makeWallet(useCache: Bool = true, success: @escaping (Zhip.Wallet) -> Void) {
        if useCache, let cached = cachedWallet {
            return success(cached)
        }

        let privateKey = PrivateKey(hex: "0507A445DAA5B543AB568BDBC8E9FBB167B45533DCEDEE0505B012677C86B3A0")!
        let password = "apabanan"
        let address = Address(privateKey: privateKey)
        Keystore.from(address: address, privateKey: privateKey, encryptBy: password) {
            guard case .success(let keystore) = $0 else {
                return XCTFail()
            }
            let _wallet = Zesame.Wallet(keystore: keystore, address: address)
            let wallet = Zhip.Wallet(wallet: _wallet, origin: .importedPrivateKey)
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
