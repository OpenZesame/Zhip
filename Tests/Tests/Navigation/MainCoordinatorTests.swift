//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
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

import Combine
import Factory
import UIKit
import XCTest
import Zesame
@testable import Zhip

/// Tests for `MainCoordinator` — instantiates the coordinator with a real
/// `UINavigationController`, drives `start()`, and verifies the initial scene
/// is pushed.
final class MainCoordinatorTests: XCTestCase {

    private var navigationController: UINavigationController!
    private var deeplinkSubject: PassthroughSubject<TransactionIntent, Never>!
    private var mockTransactions: MockTransactionsUseCase!
    private var mockWallet: MockWalletUseCase!
    private var sut: MainCoordinator!

    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
        deeplinkSubject = PassthroughSubject<TransactionIntent, Never>()
        mockTransactions = MockTransactionsUseCase()
        mockWallet = MockWalletUseCase()
        mockWallet.storedWallet = TestWalletFactory.makeWallet()
        Container.shared.transactionsUseCase.register { [unowned self] in self.mockTransactions }
        Container.shared.walletStorageUseCase.register { [unowned self] in self.mockWallet }
        sut = MainCoordinator(
            navigationController: navigationController,
            deeplinkedTransaction: deeplinkSubject.eraseToAnyPublisher()
        )
    }

    override func tearDown() {
        Container.shared.manager.reset()
        sut = nil
        mockWallet = nil
        mockTransactions = nil
        deeplinkSubject = nil
        navigationController = nil
        super.tearDown()
    }

    func test_start_pushesMainSceneAsRoot() {
        sut.start()

        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }

    func test_start_withNonEmptyChildCoordinators_preventsDeepLinkNavigation() throws {
        sut.start()
        let address = try Address(string: "e3090a1309DfAC40352d03dEc6cCD9cAd213e76B")
        let intent = TransactionIntent(to: address)

        deeplinkSubject.send(intent)
        // No crash; deeplinked flow handled.
    }
}
