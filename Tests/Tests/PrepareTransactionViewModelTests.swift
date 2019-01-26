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
//
//class PrepareTransactionViewModelTests: XCTestCase, ViewModelTesting {
//    typealias ViewModel = PrepareTransactionViewModel
//
//    var scheduler = TestScheduler(initialClock: 0)
//    var viewModel: ViewModel!
//    var cachedWallet: Zhip.Wallet?
//
//    private var deeplinkedTxSubject: PublishSubject<TransactionIntent>!
//    private var mockedWalletUseCase: MockedWalletUseCase!
//    private var mockedTransactionUseCase: MockedTransactionUseCase!
//
//    override func setUp() {
//        viewModel = nil
//        let exp = expectation(description: "\(#function)\(#line)")
//
//        scheduler = TestScheduler(initialClock: 0)
//
//        deeplinkedTxSubject = PublishSubject<TransactionIntent>()
//
//        var wallet: Zhip.Wallet!
//
//        makeWallet() {
//            wallet = $0
//            exp.fulfill()
//        }
//
//        waitForExpectations(timeout: 2, handler: nil)
//        XCTAssertNotNil(wallet)
//        XCTAssertEqual("FB431E2134a433F571C09033b663aC03499a4982", wallet.address.checksummedHex)
//        mockedWalletUseCase = MockedWalletUseCase(wallet: wallet)
//
//        mockedTransactionUseCase = MockedTransactionUseCase(balance: 0)
//
//        viewModel = ViewModel(
//            walletUseCase: mockedWalletUseCase,
//            transactionUseCase: mockedTransactionUseCase,
//            deepLinkedTransaction: deeplinkedTxSubject.asDriverOnErrorReturnEmpty()
//        )
//    }
//
//    var emptyInputFromView: InputFromView {
//        return inputFromView()
//    }
//
//    func inputFromView(
//        address: [Recorded<Event<String>>] = [],
//        addressDidEndEditing: [Recorded<Event<Void>>] = [],
//        amount: [Recorded<Event<String>>] = [],
//        amountDidEndEditing: [Recorded<Event<Void>>] = [],
//        gasPrice: [Recorded<Event<String>>] = [],
//        gasPriceDidEndEditing: [Recorded<Event<Void>>] = []
//        ) -> InputFromView {
//
//
//        return InputFromView(
//            pullToRefreshTrigger: .empty(),
//            scanQRTrigger: .empty(),
//            sendTrigger: .empty(),
//            recepientAddress: scheduler.createTestDriver(address),
//            recipientAddressDidEndEditing: scheduler.createTestDriver(addressDidEndEditing),
//            amountToSend: scheduler.createTestDriver(amount),
//            amountDidEndEditing: scheduler.createTestDriver(amountDidEndEditing),
//            gasPrice: scheduler.createTestDriver(gasPrice),
//            gasPriceDidEndEditing: scheduler.createTestDriver(gasPriceDidEndEditing)
//        )
//    }
//
//    func testHasGetBalanceBeenCalled() {
//        transformEmptyInputToOutput()
//        XCTAssertTrue(mockedTransactionUseCase.hasGetBalanceBeenCalled)
//    }
//
//    func testHasLoadWalletBeenCalled() {
//        transformEmptyInputToOutput()
//        XCTAssertTrue(mockedWalletUseCase.hasLoadWalletBeenCalled)
//    }
//
//    func testValidRecipient() {
//        let to = "F510333720c5dD3c3c08bC8e085E8C981CE74691"
//
//        let output = viewModel.transform(inputFromView:
//            inputFromView(
//                address: [.next(1, to)]
//            )
//        )
//
//        assertDriverValues {
//            let recordedRecipient = $0.record(output.recipient)
//            $0.start()
//            XCTAssertEqual(recordedRecipient.values, [to])
//        }
//    }
//
//    func testAmountLessThanAmount() {
//        XCTAssertNotNil(viewModel)
//
//        mockedTransactionUseCase.mockedBalanceResponse = 25
//
//        let expectedBalance = [
//            "25 ZILs",
//            nil // frankly I have no idea why a `nil` gets emitted.
//        ]
//
//        let expectedAmount = ["10", "20"]
//
//        let output = viewModel.transform(inputFromView:
//            inputFromView(
//                address:                [.next(1, "F510333720c5dD3c3c08bC8e085E8C981CE74691")],
//                addressDidEndEditing:   [.next(2, void)],
//                amount:                 [.next(3, expectedAmount[0]), .next(10, expectedAmount[1]), .next(20, "30")],
//                amountDidEndEditing:    [.next(4, void), .next(11, void), .next(21, void)],
//                gasPrice:               [.next(5, "100")],
//                gasPriceDidEndEditing:  [.next(6, void)]
//            )
//        )
//
//        assertDriverValues {
//            let recordedBalance = $0.record(output.balance)
//            let recordedAmount = $0.record(output.amount)
//            let recordedAmountValidation = $0.record(output.amountValidation)
//
//            $0.start()
//
//            XCTAssertEqual(recordedBalance.values, expectedBalance)
//            XCTAssertEqual(recordedAmount.values, expectedAmount)
//            let amountValidationValues: [Validation?] = recordedAmountValidation.values
//            XCTAssertEqual(amountValidationValues, [.valid, .valid, .error(errorMessage: "Insufficient funds")])
//        }
//
//    }
//}
//
//extension TestableObserver {
//    var values: [E?] {
//        return events.map { $0.value.element }
//    }
//}
//
//private extension TestScheduler {
//
//    func createTestDriver<V>(_ events: [Recorded<Event<V>>]) -> Driver<V> {
//        return createHotObservable(events).asDriver {
//            incorrectImplementation("Should be able to create Driver from TestableObservable, error:\($0)")
//        }
//    }
//}
//
//private let void: Void = ()
