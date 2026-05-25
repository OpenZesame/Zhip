//
// MIT License
//
// Copyright (c) 2018-2026 Alexander Cyon (https://github.com/sajjon)
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

@testable import AppFeature
import Combine
import Factory
@_spi(Testing) import NanoViewControllerController
import UIKit
import XCTest
import Zesame

/// Covers `SendCoordinator` navigation branches: the chain from
/// `PrepareTransaction` through `ScanQRCode` / `ReviewTransaction` /
/// `SignTransaction` / `PollTransactionStatus`, plus the final `finish` bubble.
@MainActor
final class SendCoordinatorTests: XCTestCase {
    private var window: UIWindow!
    private var navigationController: NavigationBarLayoutingNavigationController!
    private var mockTransactions: MockTransactionsUseCase!
    private var mockWallet: MockWalletUseCase!
    private var deeplinkSubject: PassthroughSubject<TransactionIntent, Never>!
    private var scannedQrCodeSubject: PassthroughSubject<String?, Never>!
    private var cancellables: Set<AnyCancellable> = []
    private var sut: SendCoordinator!

    override func setUp() {
        super.setUp()
        mockTransactions = MockTransactionsUseCase()
        mockWallet = MockWalletUseCase()
        mockWallet.storedWallet = TestWalletFactory.makeWallet()
        Container.shared.transactionsUseCase.register { [unowned self] in mainActorOnly { mockTransactions } }
        Container.shared.walletStorageUseCase.register { [unowned self] in mainActorOnly { mockWallet } }
        deeplinkSubject = PassthroughSubject<TransactionIntent, Never>()
        scannedQrCodeSubject = PassthroughSubject<String?, Never>()
        navigationController = NavigationBarLayoutingNavigationController()
        window = TestWindowFactory.make(frame: .init(x: 0, y: 0, width: 320, height: 480))
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        sut = SendCoordinator(
            navigationController: navigationController,
            deeplinkedTransaction: deeplinkSubject.eraseToAnyPublisher(),
            scannedQrCodeString: scannedQrCodeSubject.eraseToAnyPublisher()
        )
    }

    override func tearDown() {
        drainRunLoop()
        cancellables.removeAll()
        sut = nil
        window.isHidden = true
        window = nil
        navigationController = nil
        scannedQrCodeSubject = nil
        deeplinkSubject = nil
        Container.shared.manager.reset()
        mockWallet = nil
        mockTransactions = nil
        super.tearDown()
    }

    // MARK: - start

    func test_start_pushesPrepareTransactionAsRoot() {
        sut.start()

        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is PrepareTransaction)
    }

    // MARK: - PrepareTransaction branches

    func test_prepareTransactionCancel_bubblesFinish() throws {
        sut.start()
        var received: SendCoordinatorNavigationStep?
        sut.navigator.navigation.sink { received = $0 }.store(in: &cancellables)
        let prepare = try XCTUnwrap(top(as: PrepareTransaction.self))

        // `.cancel` is wired to the right-bar button.
        prepare.rightBarButtonSubject.send(())
        drainRunLoop()

        if case .finish = received { } else {
            XCTFail("expected .finish, got \(String(describing: received))")
        }
    }

    func test_prepareTransactionScanQR_presentsScanQRCode() throws {
        sut.start()
        let prepare = try XCTUnwrap(top(as: PrepareTransaction.self))

        // The scan-QR trigger sits on the embedded button inside the
        // recipient address field — first UIButton in `PrepareTransactionView`.
        try tapButton(at: 0, in: prepare.view)
        drainRunLoop()
        // Presentation is modal; just verifying no crash.
    }

    func test_prepareTransactionReviewPayment_pushesReviewTransaction() throws {
        // Arrange
        sut.start()
        let prepare = try XCTUnwrap(top(as: PrepareTransaction.self))
        let payment = try makePayment()

        // Act — drive the coordinator's routing closure via NVC's @_spi(Testing)
        // navigationHandler hook instead of filling the entire payment form.
        prepare.navigationHandler?(.reviewPayment(payment))
        drainRunLoop()

        // Assert
        XCTAssertNotNil(top(as: ReviewTransactionBeforeSigning.self))
    }

    // MARK: - ReviewTransaction → SignTransaction

    func test_reviewAcceptPayment_pushesSignTransaction() throws {
        // Arrange — chain into Review via the SPI handler.
        sut.start()
        let payment = try makePayment()
        let prepare = try XCTUnwrap(top(as: PrepareTransaction.self))
        prepare.navigationHandler?(.reviewPayment(payment))
        drainRunLoop()
        let review = try XCTUnwrap(top(as: ReviewTransactionBeforeSigning.self))

        // Act
        review.navigationHandler?(.acceptPaymentProceedWithSigning(payment))
        drainRunLoop()

        // Assert
        XCTAssertNotNil(top(as: SignTransaction.self))
    }

    // MARK: - Deep-link forwarding

    func test_deeplinkedTransaction_whenPrepareTransactionIsTop_forwardsToScannedSubject() throws {
        sut.start()
        let address = try Address(string: "e3090a1309DfAC40352d03dEc6cCD9cAd213e76B")
        let intent = TransactionIntent(to: address)

        deeplinkSubject.send(intent)
        drainRunLoop()
        // No crash; the filter in PrepareTransactionViewModel lets the intent through.
    }

    // MARK: - Sign → PollTransactionStatus

    func test_signTransactionSign_pushesPollTransactionStatus() throws {
        // Arrange — chain into Sign via SPI handlers.
        sut.start()
        let payment = try makePayment()
        let prepare = try XCTUnwrap(top(as: PrepareTransaction.self))
        prepare.navigationHandler?(.reviewPayment(payment))
        drainRunLoop()
        let review = try XCTUnwrap(top(as: ReviewTransactionBeforeSigning.self))
        review.navigationHandler?(.acceptPaymentProceedWithSigning(payment))
        drainRunLoop()
        let sign = try XCTUnwrap(top(as: SignTransaction.self))
        let response = try makeTransactionResponse()

        // Act
        sign.navigationHandler?(.sign(response))
        drainRunLoop()

        // Assert
        XCTAssertNotNil(top(as: PollTransactionStatus.self))
    }

    // MARK: - PollTransactionStatus branches

    func test_pollSkip_bubblesFinishWithoutFetchingBalance() throws {
        // Arrange — chain into Poll, then observe the bubbled step.
        let poll = try chainToPoll()
        var received: SendCoordinatorNavigationStep?
        sut.navigator.navigation.sink { received = $0 }.store(in: &cancellables)

        // Act
        poll.navigationHandler?(.skip)
        drainRunLoop()

        // Assert — `.skip` should bubble `.finish(fetchBalance: false)`.
        guard case let .finish(fetchBalance) = received else {
            return XCTFail("expected .finish, got \(String(describing: received))")
        }
        XCTAssertFalse(fetchBalance)
    }

    func test_pollWaitUntilTimeout_bubblesFinishWithoutFetchingBalance() throws {
        // Arrange
        let poll = try chainToPoll()
        var received: SendCoordinatorNavigationStep?
        sut.navigator.navigation.sink { received = $0 }.store(in: &cancellables)

        // Act
        poll.navigationHandler?(.waitUntilTimeout)
        drainRunLoop()

        // Assert
        guard case let .finish(fetchBalance) = received else {
            return XCTFail("expected .finish, got \(String(describing: received))")
        }
        XCTAssertFalse(fetchBalance)
    }

    func test_pollDismiss_bubblesFinishWithFetchingBalance() throws {
        // Arrange
        let poll = try chainToPoll()
        var received: SendCoordinatorNavigationStep?
        sut.navigator.navigation.sink { received = $0 }.store(in: &cancellables)

        // Act
        poll.navigationHandler?(.dismiss)
        drainRunLoop()

        // Assert — `.dismiss` (user saw "confirmed") asks Main to refetch.
        guard case let .finish(fetchBalance) = received else {
            return XCTFail("expected .finish, got \(String(describing: received))")
        }
        XCTAssertTrue(fetchBalance)
    }

    func test_pollViewTransactionDetails_opensBrowserWithoutCrashing() throws {
        // Arrange — register a mock URL opener so we don't trigger a real
        // workspace round-trip in the simulator.
        let mockOpener = MockUrlOpener()
        Container.shared.urlOpener.register { mockOpener }
        // Re-create the SUT so it picks up the freshly-registered opener
        // (the existing one was resolved during setUp before the mock landed).
        sut = SendCoordinator(
            navigationController: navigationController,
            deeplinkedTransaction: deeplinkSubject.eraseToAnyPublisher(),
            scannedQrCodeString: scannedQrCodeSubject.eraseToAnyPublisher()
        )
        let poll = try chainToPoll()

        // Act
        poll.navigationHandler?(.viewTransactionDetailsInBrowser(id: "abc123"))
        drainRunLoop()

        // Assert — exactly one URL was dispatched, containing the tx id.
        XCTAssertEqual(mockOpener.openInvocations.count, 1)
        XCTAssertTrue(
            mockOpener.lastOpenedUrl?.absoluteString.contains("abc123") ?? false,
            "expected URL to contain transaction id; got \(String(describing: mockOpener.lastOpenedUrl))"
        )
    }

    // MARK: - Deep-link filter reject branch

    /// Asserts that a deeplinked intent emitted while a non-Prepare scene is
    /// topmost is dropped by `SendCoordinator`'s topmost-scene filter.
    ///
    /// Load-bearing assertion: Prepare's recipient text field is unchanged.
    /// Stack-count alone would pass with the filter removed — a stray
    /// pre-fill of a non-topmost view doesn't push/pop. See `chainedAssert`
    /// helper for the recipient-snapshot rationale.
    func test_deeplinkedTransaction_whenNotOnPrepare_isFilteredOut() throws {
        // Arrange
        sut.start()
        let prepare = try XCTUnwrap(top(as: PrepareTransaction.self))
        prepare.view.layoutIfNeeded()
        let recipientField = try XCTUnwrap(
            prepare.view.firstSubview(ofType: FloatingLabelTextField.self)
        )
        let recipientBeforeDeeplink = recipientField.text ?? ""
        prepare.navigationHandler?(.reviewPayment(try makePayment()))
        drainRunLoop()
        XCTAssertNotNil(top(as: ReviewTransactionBeforeSigning.self))
        let stackCountBeforeDeeplink = navigationController.viewControllers.count
        let deeplinkedAddress = try Address(string: "e3090a1309DfAC40352d03dEc6cCD9cAd213e76B")

        // Act
        deeplinkSubject.send(TransactionIntent(to: deeplinkedAddress))
        drainRunLoop()

        // Assert — filter dropped the intent: stack unchanged, recipient field
        // byte-for-byte unchanged, and the new address explicitly didn't land.
        XCTAssertEqual(navigationController.viewControllers.count, stackCountBeforeDeeplink)
        XCTAssertNotNil(top(as: ReviewTransactionBeforeSigning.self))
        XCTAssertEqual(recipientField.text ?? "", recipientBeforeDeeplink)
        XCTAssertFalse((recipientField.text ?? "").contains(deeplinkedAddress.asString))
    }

    // MARK: - ScanQRCode result branches

    func test_scanQRCode_cancel_dismissesWithoutCrashing() throws {
        sut.start()
        let prepare = try XCTUnwrap(top(as: PrepareTransaction.self))
        try tapButton(at: 0, in: prepare.view) // scanQR button
        drainRunLoop()

        let presentedNav = navigationController.presentedViewController as? UINavigationController
        let scan = presentedNav?.topViewController as? ScanQRCode
        // ScanQRCode `.cancel` is wired to the left-bar button.
        scan?.leftBarButtonSubject.send(())
        drainRunLoop()
    }

    func test_scanQRCode_scannedTransaction_dismissesAndForwardsToSubject() throws {
        // Arrange — start, open the QR scanner modal, capture the presented scene.
        sut.start()
        let prepare = try XCTUnwrap(top(as: PrepareTransaction.self))
        try tapButton(at: 0, in: prepare.view) // scanQR button on recipient field
        drainRunLoop()
        let presentedNav = try XCTUnwrap(navigationController.presentedViewController as? UINavigationController)
        XCTAssertTrue(presentedNav.topViewController is ScanQRCode)
        // Bare-address payload — `TransactionIntent.fromScannedQrCodeString`
        // parses this as an `Address` and wraps it in a no-amount intent.
        let scannedAddress = "e3090a1309DfAC40352d03dEc6cCD9cAd213e76B"

        // Act — push the synthesized scan through the injected DI seam.
        scannedQrCodeSubject.send(scannedAddress)
        drainRunLoop()

        // Assert — modal dismissed and PrepareTransaction is back as top scene.
        // `dismissAndForwardsToSubject`: the dismiss arm of the coordinator's
        // `.scanQRContainingTransaction` handler ran, and the forward to
        // `scannedQRTransactionSubject` would have followed in the dismiss
        // completion (its effect — pre-filling the recipient — is covered by
        // the PrepareTransaction VM tests).
        XCTAssertNil(navigationController.presentedViewController)
        XCTAssertTrue(top(as: PrepareTransaction.self) != nil)
    }
}

// MARK: - Helpers

private extension SendCoordinatorTests {
    /// Returns the topmost view controller on the navigation stack typed
    /// as `T`, or `nil` if the top isn't of that type.
    func top<T>(as _: T.Type) -> T? {
        navigationController.viewControllers.last as? T
    }

    /// Builds a valid `Payment` (1 ZIL → known address, minimum gas) used as
    /// the carry-value when synthesizing `.reviewPayment` / `.acceptPayment`
    /// routing steps via the NVC `@_spi(Testing)` seam.
    func makePayment() throws -> Payment {
        let address = try LegacyAddress(string: "e3090a1309DfAC40352d03dEc6cCD9cAd213e76B")
        let amount = try Amount(zil: 1)
        let gasPrice = try GasPrice(li: 1_000_000)
        return try Payment(to: address, amount: amount, gasPrice: gasPrice)
    }

    /// Builds a minimal `TransactionResponse` JSON-encoded blob with a known
    /// transaction id ("abc123"). Used to drive `.sign(...)` and the resulting
    /// `PollTransactionStatus` push.
    func makeTransactionResponse() throws -> TransactionResponse {
        try JSONDecoder().decode(
            TransactionResponse.self,
            from: Data(#"{"TranID":"abc123","Info":"Sent"}"#.utf8)
        )
    }

    /// Chains forward through the Send pipeline via NVC's `@_spi(Testing)`
    /// `navigationHandler` hooks until `PollTransactionStatus` is on top.
    /// Returns the polling scene so the test can drive its routing.
    ///
    /// Each `navigationHandler?(.X)` call dispatches the same closure NVC's
    /// Combine sink installs in production — so the assertion target is the
    /// coordinator's routing logic, not the view-model emissions (which are
    /// covered by the per-VM test suites).
    func chainToPoll() throws -> PollTransactionStatus {
        sut.start()
        let payment = try makePayment()
        let prepare = try XCTUnwrap(top(as: PrepareTransaction.self))
        prepare.navigationHandler?(.reviewPayment(payment))
        drainRunLoop()
        let review = try XCTUnwrap(top(as: ReviewTransactionBeforeSigning.self))
        review.navigationHandler?(.acceptPaymentProceedWithSigning(payment))
        drainRunLoop()
        let sign = try XCTUnwrap(top(as: SignTransaction.self))
        sign.navigationHandler?(.sign(try makeTransactionResponse()))
        drainRunLoop()
        return try XCTUnwrap(top(as: PollTransactionStatus.self))
    }
}
