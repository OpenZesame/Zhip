//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-02-11.
//

import Foundation

public final class Wallet: Codable, ObservableObject {
    public let name: String
    public init(name: String) {
        self.name = name
    }
}
