//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-19.
//

import ComposableArchitecture
import Combine
import Foundation
import KeychainManager

public extension KeychainClient {
	static func live(
		keychain keychainWrapper: KeychainManager = .init(
			service: "com.openzesame.zhip",
			label: "Zhip",
			accessibility: .whenPasscodeSetThisDeviceOnly
		)
	) -> Self {
		Self(
			dataForKey: { key in
				Effect.run { subscriber in
					do {
						let data = try keychainWrapper.data(forKey: key)
						subscriber.send(data)
						subscriber.send(completion: .finished)
					} catch {
						subscriber.send(completion: .failure(Self.Error.keychainReadError(reason: String(describing: error))))
					}
					return AnyCancellable {}
				}
			},
			remove: { key in
				Effect.run { subscriber in
					do {
						try keychainWrapper.remove(forKey: key)
						subscriber.send(())
						subscriber.send(completion: .finished)
					} catch {
						subscriber.send(completion: .failure(Self.Error.keychainRemoveError(reason: String(describing: error))))
					}
					return AnyCancellable {}
				}
			},
			setData: { data, key in
				Effect.run { subscriber in
					do {
						try keychainWrapper.setData(data, forKey: key)
						subscriber.send(())
						subscriber.send(completion: .finished)
					}catch {
						subscriber.send(completion: .failure(Self.Error.keychainWriteError(reason: String(describing: error))))
					}
					return AnyCancellable {}
				}
			}
		)
	}
}

