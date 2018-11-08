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

    public static let shared = DefaultZilliqaService()

    public let apiClient: APIClient = DefaultAPIClient()

    private init() {}
}

public extension DefaultZilliqaService {

    func getBalalance(for address: Address, done: @escaping Done<BalanceResponse>) -> Void {
        return apiClient.send(request: BalanceRequest(address: address), done: done)
    }

    func send(transaction: Transaction, done: @escaping Done<TransactionResponse>) {
        return apiClient.send(request: TransactionRequest(transaction: transaction), done: done)
    }
}
