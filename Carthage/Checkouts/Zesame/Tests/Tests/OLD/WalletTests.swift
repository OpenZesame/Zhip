//
//  WalletTests.swift
//  ZesameTests-iOS
//
//  Created by Alexander Cyon on 2018-05-26.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import EllipticCurveKeyPair

import XCTest
@testable import Zesame_iOS

class WalletTests: XCTestCase {

    func testCreatingWallet() {
        let wallet = Wallet()
        let keyCreationExpectation = expectation(description: "create keychain")
        wallet.createPrivateKeyAndValidate() { result in
            switch result {
            case .success(let privateKey): print(privateKey); XCTAssertTrue(true)
            case .error(let error):
                XCTFail("Failed due to internal error: \(error)")
            }
            keyCreationExpectation.fulfill()
        }
        waitForExpectations(timeout: 30)
    }
}
