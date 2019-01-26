// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
