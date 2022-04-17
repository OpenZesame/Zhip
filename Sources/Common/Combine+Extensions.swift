//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-04-17.
//

import Foundation
import Combine


extension Publisher where Output: OptionalType {
	public func flatMap<T, E, P>(
		ifPresent transformation: @escaping (Output.Wrapped) -> P,
		mapError mapErrorFn: @escaping (P.Failure) -> E
	) -> AnyPublisher<T?, E>
	where
P: Publisher,
	P.Output == T
	{
		self.mapError { $0 as Swift.Error  }
			.flatMap { (`optional`: Output) -> AnyPublisher<T?, Swift.Error> in
				
				guard let wrapped = `optional`.wrapped else {
					return Just(nil)
						.setFailureType(to: Swift.Error.self)
						.eraseToAnyPublisher()
				}
				
				return transformation(wrapped)
					.map { indeed in T?.some(indeed) }
					.mapError { $0 as Swift.Error }
					.eraseToAnyPublisher()
			}
			.mapError { $0 as! P.Failure }
			.mapError(mapErrorFn)
			.eraseToAnyPublisher()
	}
}

