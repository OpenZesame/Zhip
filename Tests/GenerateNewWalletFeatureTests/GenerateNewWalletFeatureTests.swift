//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-27.
//

import Foundation
import ComposableArchitecture
import GenerateNewWalletFeature
import XCTest

final class GenerateNewWalletFeatureTests: XCTestCase{
	func testCannotProceedWithoutValidPasswords() {
        XCTAssertFalse(GenerateNewWallet.State().isContinueButtonEnabled)
	}
}
