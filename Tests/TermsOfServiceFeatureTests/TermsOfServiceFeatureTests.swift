//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-27.
//

import Foundation
import ComposableArchitecture
import XCTest
@testable import TermsOfServiceFeature

final class TermsOfServiceFeatureTests: XCTestCase {
	func testStateModeStartsAsMandatory() {
		XCTAssertEqual(TermsOfServiceState().mode, .mandatoryToAcceptTermsAsPartOfOnboarding)
	}
}
