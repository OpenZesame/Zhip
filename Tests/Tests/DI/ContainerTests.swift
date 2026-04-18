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

import Factory
import XCTest
@testable import Zhip

/// Tests the Factory-compatible DI container: register, resolve, reset.
///
/// We exercise the container exclusively through the `preferences` factory because
/// registering a mock `Preferences` is side-effect-free — it doesn't try to open a
/// network connection or touch the Keychain.
final class ContainerTests: XCTestCase {

    override func tearDown() {
        Container.shared.manager.reset()
        super.tearDown()
    }

    // MARK: - Factory.callAsFunction / register

    func test_register_overridesDefaultFactory() {
        // Arrange
        let mock = TestStoreFactory.makePreferences()
        Container.shared.preferences.register { mock }

        // Act
        let resolved = Container.shared.preferences()

        // Assert
        // Two `Preferences` values are equal iff they share the same backing closures;
        // instead we verify identity by mutating and re-reading through both refs.
        mock.save(value: true, for: .hasAcceptedTermsOfService)
        XCTAssertTrue(resolved.isTrue(.hasAcceptedTermsOfService))
    }

    // MARK: - reset()

    func test_reset_restoresDefaultFactory() {
        // Arrange
        let mock = TestStoreFactory.makePreferences()
        Container.shared.preferences.register { mock }

        // Act
        Container.shared.manager.reset()

        // Assert: after reset, the old mock is no longer seen.
        mock.save(value: true, for: .hasAcceptedTermsOfService)
        XCTAssertFalse(Container.shared.preferences().isTrue(.hasAcceptedTermsOfService))
    }

    // MARK: - narrow use case factories

    func test_createWalletUseCase_registerOverridesDefault() {
        // Arrange
        let mock = MockWalletUseCase()
        Container.shared.createWalletUseCase.register { mock }

        // Act
        let resolved = Container.shared.createWalletUseCase()

        // Assert
        XCTAssertTrue((resolved as AnyObject) === mock)
    }

    func test_walletStorageUseCase_isSharedAcrossResolutions() {
        // Arrange
        let mock = MockWalletUseCase()
        Container.shared.walletStorageUseCase.register { mock }

        // Act
        let resolvedA = Container.shared.walletStorageUseCase()
        let resolvedB = Container.shared.walletStorageUseCase()

        // Assert — singleton scope returns the same instance.
        XCTAssertTrue((resolvedA as AnyObject) === (resolvedB as AnyObject))
        XCTAssertTrue((resolvedA as AnyObject) === mock)
    }
}
