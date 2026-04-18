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
@testable import Zhip

/// Covers `ChooseWalletCoordinator` routing: `.createNewWallet` /
/// `.restoreWallet` branches, each presenting a child modal coordinator.
final class ChooseWalletCoordinatorTests: XCTestCase {

    private var window: UIWindow!
    private var navigationController: NavigationBarLayoutingNavigationController!
    private var mockWallet: MockWalletUseCase!
    private var cancellables: Set<AnyCancellable> = []
    private var sut: ChooseWalletCoordinator!

    override func setUp() {
        super.setUp()
        mockWallet = MockWalletUseCase()
        Container.shared.walletStorageUseCase.register { [unowned self] in self.mockWallet }
        navigationController = NavigationBarLayoutingNavigationController()
        window = UIWindow(frame: .init(x: 0, y: 0, width: 320, height: 480))
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        sut = ChooseWalletCoordinator(navigationController: navigationController)
    }

    override func tearDown() {
        drainRunLoop()
        cancellables.removeAll()
        sut = nil
        window.isHidden = true
        window = nil
        navigationController = nil
        Container.shared.manager.reset()
        mockWallet = nil
        super.tearDown()
    }

    // MARK: - Helpers

    private func drainRunLoop(seconds: TimeInterval = 0.1) {
        let expectation = expectation(description: "runloop drain")
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { expectation.fulfill() }
        wait(for: [expectation], timeout: seconds + 1)
    }

    private func top<T>(as _: T.Type) -> T? {
        navigationController.viewControllers.last as? T
    }

    // MARK: - start

    func test_start_pushesChooseWalletAsRoot() {
        sut.start()

        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is ChooseWallet)
    }

    // MARK: - Branches

    func test_createNewWallet_startsCreateNewWalletChildCoordinator() {
        sut.start()
        let choose = top(as: ChooseWallet.self)!

        choose.viewModel.navigator.next(.createNewWallet)
        drainRunLoop()

        XCTAssertTrue(sut.childCoordinators.contains { $0 is CreateNewWalletCoordinator })
    }

    func test_restoreWallet_startsRestoreWalletChildCoordinator() {
        sut.start()
        let choose = top(as: ChooseWallet.self)!

        choose.viewModel.navigator.next(.restoreWallet)
        drainRunLoop()

        XCTAssertTrue(sut.childCoordinators.contains { $0 is RestoreWalletCoordinator })
    }
}
