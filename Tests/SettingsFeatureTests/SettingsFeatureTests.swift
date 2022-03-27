//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-27.
//

import Foundation
import ComposableArchitecture
@testable import SettingsFeature
import XCTest

final class SettingsFeatureTests: XCTestCase {
	func testSettingsAlertStartsAsNil() {
		XCTAssertNil(SettingsState().alert)
	}
}
