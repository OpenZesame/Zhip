//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-02-23.
//

import Foundation
import Zesame

public struct Contact: Hashable {

    public let address: Address
    public let name: String?

    public init(address: Address, name: String? = nil) {
        self.address = address
        self.name = name
    }
}
