//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-29.
//

import Combine
import ComposableArchitecture
import Foundation
import XCTest
import WalletGenerator
import Wallet
@testable import WalletGeneratorUnsafeFast

final class WalletGeneratorUnsafeFastTests: XCTestCase {
	
	var cancellables: Set<AnyCancellable> = []
	
	func testKeystoreDEBUG() throws {
		let request = GenerateWalletRequest(encryptionPassword: "apabanan")
		let walletGenerator: WalletGenerator = .unsafeFast()
		let walletExp = expectation(description: "Wallet generator")
		var maybeWallet: Wallet?
		
		walletGenerator
			.generate(request)
			.sink(
				receiveCompletion: {
					switch $0 {
					case .finished:
						walletExp.fulfill()
					case .failure:
						XCTFail()
					}
				},
				receiveValue: {
					maybeWallet = $0
				}
			)
			.store(in: &cancellables)
		waitForExpectations(timeout: 5)
		
		
		let wallet = try XCTUnwrap(maybeWallet)
		let keystore = wallet.keystore
		let jsonEncoder = JSONEncoder()
		jsonEncoder.outputFormatting = .prettyPrinted
		let jsonData = try jsonEncoder.encode(keystore)
		let jsonString = try XCTUnwrap(String(data: jsonData, encoding: .utf8))
		print(jsonString)
		XCTAssertTrue(jsonString.contains("crypto"))
	}
}
