//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-02-13.
//

import Foundation
import Zesame

public let network: Network = .mainnet

public enum ZilliqaAPIEndpoint: String {
    case mainnet = "https://api.zilliqa.com"
    case testnet = "https://dev-api.zilliqa.com"
}

public extension ZilliqaAPIEndpoint {
    var baseURL: URL {
        guard let url = URL(string: rawValue) else {
            fatalError("Incorrect implementation should be able to construct url")
        }
        return url
    }
}
