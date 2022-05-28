//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-27.
//

import Foundation
import ComposableArchitecture
import XCTest
@testable import SplashFeature

final class SplashFeatureTests: XCTestCase {
	func testAlertStartsAsNil() throws {
        XCTAssertNil(Splash.State().alert)
	}
}
