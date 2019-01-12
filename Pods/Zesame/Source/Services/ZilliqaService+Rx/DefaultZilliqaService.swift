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

    public let apiClient: APIClient

    private init(apiClient: APIClient = DefaultAPIClient()) {
        self.apiClient = apiClient
    }
}

public extension DefaultZilliqaService {
    convenience init(environment: ZilliqaEnvironment) {
        self.init(apiClient: DefaultAPIClient(environment: environment))
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
