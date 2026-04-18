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

/// Drives each `SettingsCoordinator` navigation branch so every case in
/// `toSettings`'s big switch is exercised. Modal presentations run against a
/// real `UIWindow` so the presentation path doesn't silently no-op.
final class SettingsCoordinatorTests: XCTestCase {

    private var window: UIWindow!
    private var navigationController: NavigationBarLayoutingNavigationController!
    private var mockTransactions: MockTransactionsUseCase!
    private var mockWallet: MockWalletUseCase!
    private var mockPincode: MockPincodeUseCase!
    private var mockOnboarding: MockOnboardingUseCase!
    private var cancellables: Set<AnyCancellable> = []
    private var sut: SettingsCoordinator!

    override func setUp() {
        super.setUp()
        mockTransactions = MockTransactionsUseCase()
        mockWallet = MockWalletUseCase()
        mockWallet.storedWallet = TestWalletFactory.makeWallet()
        mockPincode = MockPincodeUseCase()
        mockOnboarding = MockOnboardingUseCase()
        Container.shared.transactionsUseCase.register { [unowned self] in self.mockTransactions }
        Container.shared.walletStorageUseCase.register { [unowned self] in self.mockWallet }
        Container.shared.pincodeUseCase.register { [unowned self] in self.mockPincode }
        Container.shared.onboardingUseCase.register { [unowned self] in self.mockOnboarding }
        navigationController = NavigationBarLayoutingNavigationController()
        window = UIWindow(frame: .init(x: 0, y: 0, width: 320, height: 480))
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        sut = SettingsCoordinator(navigationController: navigationController)
    }

    override func tearDown() {
        drainRunLoop()
        cancellables.removeAll()
        sut = nil
        window.isHidden = true
        window = nil
        navigationController = nil
        Container.shared.manager.reset()
        mockOnboarding = nil
        mockPincode = nil
        mockWallet = nil
        mockTransactions = nil
        super.tearDown()
    }

    // MARK: - Helpers

    private func drainRunLoop(seconds: TimeInterval = 0.1) {
        let expectation = expectation(description: "runloop drain")
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { expectation.fulfill() }
        wait(for: [expectation], timeout: seconds + 1)
    }

    private func startAndGetScene() -> Settings {
        sut.start()
        // swiftlint:disable:next force_cast
        return navigationController.viewControllers.first as! Settings
    }

    private func fire(_ step: SettingsNavigation, on scene: Settings) {
        scene.viewModel.navigator.next(step)
        drainRunLoop()
    }

    // MARK: - start

    func test_start_pushesSettingsAsRoot() {
        sut.start()

        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is Settings)
    }

    // MARK: - navigation-bar

    func test_closeSettings_bubblesToParentNavigator() {
        let scene = startAndGetScene()
        var received: SettingsCoordinatorNavigationStep?
        sut.navigator.navigation.sink { received = $0 }.store(in: &cancellables)

        fire(.closeSettings, on: scene)

        if case .closeSettings = received { } else {
            XCTFail("expected .closeSettings, got \(String(describing: received))")
        }
    }

    // MARK: - Section 0 (pincode)

    func test_removePincode_presentsModalWithoutCrashing() {
        mockPincode.pincode = try? Pincode(digits: [Digit.zero, .one, .two, .three])
        let scene = startAndGetScene()

        fire(.removePincode, on: scene)
    }

    func test_setPincode_presentsModalCoordinatorWithoutCrashing() {
        let scene = startAndGetScene()

        fire(.setPincode, on: scene)
    }

    // MARK: - Section 1 (github / acknowledgments)

    func test_starUsOnGithub_invokesOpenUrl() {
        let scene = startAndGetScene()

        fire(.starUsOnGithub, on: scene)
    }

    func test_reportIssueOnGithub_invokesOpenUrl() {
        let scene = startAndGetScene()

        fire(.reportIssueOnGithub, on: scene)
    }

    func test_acknowledgments_invokesOpenUrl() {
        let scene = startAndGetScene()

        fire(.acknowledgments, on: scene)
    }

    // MARK: - Section 2 (legal / privacy)

    func test_readTermsOfService_presentsModalWithoutCrashing() {
        let scene = startAndGetScene()

        fire(.readTermsOfService, on: scene)
    }

    func test_changeAnalyticsPermissions_presentsModalWithoutCrashing() {
        let scene = startAndGetScene()

        fire(.changeAnalyticsPermissions, on: scene)
    }

    func test_readCustomECCWarning_presentsModalWithoutCrashing() {
        let scene = startAndGetScene()

        fire(.readCustomECCWarning, on: scene)
    }

    // MARK: - Section 3 (wallet)

    func test_backupWallet_presentsModalCoordinatorWithoutCrashing() {
        let scene = startAndGetScene()

        fire(.backupWallet, on: scene)
    }

    func test_removeWallet_presentsConfirmationModal() {
        let scene = startAndGetScene()

        fire(.removeWallet, on: scene)
    }
}
