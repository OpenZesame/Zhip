//
//  PrepareTransactionViewModelTests.swift
//  ZupremeTests
//
//  Created by Alexander Cyon on 2018-12-17.
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

class PrepareTransactionViewModelTests: XCTestCase, ViewModelTesting {
    typealias ViewModel = PrepareTransactionViewModel

    var scheduler = TestScheduler(initialClock: 0)
    var viewModel: ViewModel!
    var cachedWallet: Zupreme.Wallet?

    private var deeplinkedTxSubject: PublishSubject<TransactionIntent>!
    private var mockedWalletUseCase: MockedWalletUseCase!
    private var mockedTransactionUseCase: MockedTransactionUseCase!

    override func setUp() {
        viewModel = nil
        let exp = expectation(description: "\(#function)\(#line)")

        scheduler = TestScheduler(initialClock: 0)

        deeplinkedTxSubject = PublishSubject<TransactionIntent>()

        var wallet: Zupreme.Wallet!

        makeWallet() {
            wallet = $0
            exp.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertNotNil(wallet)
        XCTAssertEqual("FB431E2134a433F571C09033b663aC03499a4982", wallet.address.checksummedHex)
        mockedWalletUseCase = MockedWalletUseCase(wallet: wallet)

        mockedTransactionUseCase = MockedTransactionUseCase(balance: 0)

        viewModel = ViewModel(
            walletUseCase: mockedWalletUseCase,
            transactionUseCase: mockedTransactionUseCase,
            deepLinkedTransaction: deeplinkedTxSubject.asDriverOnErrorReturnEmpty()
        )
    }

    var emptyInputFromView: InputFromView {
        return inputFromView()
    }

    func inputFromView(
        address: [Recorded<Event<String>>] = [],
        addressDidEndEditing: [Recorded<Event<Void>>] = [],
        amount: [Recorded<Event<String>>] = [],
        amountDidEndEditing: [Recorded<Event<Void>>] = [],
        gasPrice: [Recorded<Event<String>>] = [],
        gasPriceDidEndEditing: [Recorded<Event<Void>>] = []
        ) -> InputFromView {


        return InputFromView(
            pullToRefreshTrigger: .empty(),
            scanQRTrigger: .empty(),
            sendTrigger: .empty(),
            recepientAddress: scheduler.createTestDriver(address),
            recipientAddressDidEndEditing: scheduler.createTestDriver(addressDidEndEditing),
            amountToSend: scheduler.createTestDriver(amount),
            amountDidEndEditing: scheduler.createTestDriver(amountDidEndEditing),
            gasPrice: scheduler.createTestDriver(gasPrice),
            gasPriceDidEndEditing: scheduler.createTestDriver(gasPriceDidEndEditing)
        )
    }

    func testHasGetBalanceBeenCalled() {
        transformEmptyInputToOutput()
        XCTAssertTrue(mockedTransactionUseCase.hasGetBalanceBeenCalled)
    }

    func testHasLoadWalletBeenCalled() {
        transformEmptyInputToOutput()
        XCTAssertTrue(mockedWalletUseCase.hasLoadWalletBeenCalled)
    }

    func testTrivialBalance() {
        mockedTransactionUseCase.mockedBalanceResponse = 237
        assertEventsFromDefaultOutput(driverAt: \.balance, equals: ["237 ZILs"])
    }

    func testValidRecipient() {
        let to = "F510333720c5dD3c3c08bC8e085E8C981CE74691"

        let output = viewModel.transform(inputFromView:
            inputFromView(
                address: [.next(1, to)]
            )
        )

        assertEvents(from: output, driverAt: \.recipient, equals: [to])
    }

    func testAmountLessThanAmount() {
        XCTAssertNotNil(viewModel)

        mockedTransactionUseCase.mockedBalanceResponse = 237
        let amount = "10"

        let output = viewModel.transform(inputFromView:
            inputFromView(
                address:                [.next(1, "F510333720c5dD3c3c08bC8e085E8C981CE74691")],
                addressDidEndEditing:   [.next(2, void)],
                amount:                 [.next(3, amount)],
                amountDidEndEditing:    [.next(4, void)],
                gasPrice:               [.next(5, "100")],
                gasPriceDidEndEditing:  [.next(6, void)]
            )
        )

        assertEvents(from: output, driverAt: \.amount, equals: [amount])
    }
}

private extension TestScheduler {

    func createTestDriver<V>(_ events: [Recorded<Event<V>>]) -> Driver<V> {
        return createHotObservable(events).asDriver {
            incorrectImplementation("Should be able to create Driver from TestableObservable, error:\($0)")
        }
    }
}

private let void: Void = ()
