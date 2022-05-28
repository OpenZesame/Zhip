//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-05-28.
//

import Foundation
import Zesame

public enum TokenID: Hashable {
    case zilling
    case token(symbol: String, contractAddress: Bech32Address)
    
    public var symbol: String {
        switch self {
        case .zilling: return "Zil"
        case .token(let symbol, _):
            return symbol
        }
    }

    /// Governance Zilliqa
    public static let gZil = try! Self.token(
        symbol: "gZIL",
        contractAddress: Bech32Address(bech32String: "zil14pzuzq6v6pmmmrfjhczywguu0e97djepxt8g3e")
    )
    
    /// XCAD Network
    public static let xcad = try! Self.token(
        symbol: "XCAD",
        contractAddress: Bech32Address(bech32String: "zil1z5l74hwy3pc3pr3gdh3nqju4jlyp0dzkhq2f5y")
    )
    
    /// StraitsX Singapore Dollar
    public static let xsgd = try! Self.token(
        symbol: "XSGD",
        contractAddress: Bech32Address(bech32String: "zil1zu72vac254htqpg3mtywdcfm84l3dfd9qzww8t")
    )
    
    /// ZilSwap
    public static let zwap = try! Self.token(
        symbol: "ZWAP",
        contractAddress: Bech32Address(bech32String: "zil1p5suryq6q647usxczale29cu3336hhp376c627")
    )
}

public struct TokenBalance: Hashable, Identifiable {
    public typealias ID = TokenID

    public let amount: Amount
    public let token: TokenID
    public var id: ID { token }
    
    public static func zil(_ amount: Amount) -> Self {
        .init(amount: amount, token: .zilling)
    }
    public static func gZil(_ amount: Amount) -> Self {
        .init(amount: amount, token: .gZil)
    }
    public static func zwap(_ amount: Amount) -> Self {
        .init(amount: amount, token: .zwap)
    }
    public static func xsgd(_ amount: Amount) -> Self {
        .init(amount: amount, token: .xsgd)
    }
    public static func xcad(_ amount: Amount) -> Self {
        .init(amount: amount, token: .xcad)
    }
}
