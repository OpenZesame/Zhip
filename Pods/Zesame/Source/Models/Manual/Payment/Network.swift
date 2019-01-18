//
//  Network.swift
//  Zesame
//
//  Created by Alexander Cyon on 2019-01-12.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation
import EllipticCurveKit

public enum Network {
    case mainnet
    case testnet(Testnet)
    public enum Testnet {
        case prod
        case staging
    }
}

public extension Network {
    var baseURL: URL {
        let baseUrlString: String
        switch self {
        case .mainnet: baseUrlString = "https://api.zilliqa.com"
        case .testnet(let testnet):
            switch testnet {
            case .prod:
                // Before mainnet launch testnet prod is "borrowing" that url.
                return Network.mainnet.baseURL
            case .staging: baseUrlString = "https://staging-api.aws.zilliqa.com"
            }
        }
        return URL(string: baseUrlString)!
    }
    
    var chainId: UInt32 {
        switch self {
        case .mainnet: return 1
        case .testnet: return 62
        }
    }
}
