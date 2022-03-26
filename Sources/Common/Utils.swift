//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-02-13.
//

import Foundation

public func incorrectImplementation(_ message: CustomStringConvertible) -> Never {
    fatalError("Incorrect implementation - \(message.description)")
}

public var abstract: Never {
    fatalError("Override me")
}


#if DEBUG
public let unsafeDebugPassword = "apabanan"
#endif
