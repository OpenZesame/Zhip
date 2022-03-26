//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-26.
//

import ComposableArchitecture
import Foundation
import UserDefaultsClient
import KeychainClient

public struct PurgeRequest: Equatable {
	public let keepHasAppRunBeforeFlag: Bool
	public let keepHasAcceptedTermsOfService: Bool
	
	public init(
		keepHasAppRunBeforeFlag: Bool = true,
		keepHasAcceptedTermsOfService: Bool = true
	) {
		self.keepHasAppRunBeforeFlag = keepHasAppRunBeforeFlag
		self.keepHasAcceptedTermsOfService = keepHasAcceptedTermsOfService
	}
}

public struct Purger {
	
	public typealias Purge = (PurgeRequest) -> Effect<Never, Never>
	
	public var purge: Purge
	
	public init(purge: @escaping Purge) {
		self.purge = purge
	}
	
	public init(
		userDefaultsClient: UserDefaultsClient,
		keychainClient: KeychainClient
	) {
		self.init(purge: { request in
			return Effect.merge(
				userDefaultsClient.removeAll(
					butKeepHasAppRunBeforeFlag: request.keepHasAppRunBeforeFlag,
					butKeepHasAcceptedTermsOfService: request.keepHasAcceptedTermsOfService
				)
				.fireAndForget(),
				
				keychainClient.removeAll().fireAndForget()
			)
		})
	}
}
