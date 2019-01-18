//
//  DefaultZilliqaService.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-09-10.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import JSONRPCKit
import APIKit
import EllipticCurveKit

public final class DefaultZilliqaService: ZilliqaService, ReactiveCompatible {

    public let apiClient: APIClient
    public let network: Network

    public init(network: Network, apiClient: APIClient? = nil) {
        self.network = network
        self.apiClient = apiClient ?? DefaultAPIClient(network: network)
    }
}


public extension DefaultZilliqaService {

    func getBalance(for address: AddressChecksummedConvertible, done: @escaping Done<BalanceResponse>) -> Void {
        return apiClient.send(request: BalanceRequest(address: address), done: done)
    }

    func send(transaction: SignedTransaction, done: @escaping Done<TransactionResponse>) {
        return apiClient.send(request: TransactionRequest(transaction: transaction), done: done)
    }
}
