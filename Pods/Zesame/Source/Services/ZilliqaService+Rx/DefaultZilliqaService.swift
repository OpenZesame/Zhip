//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import RxSwift
import JSONRPCKit
import APIKit
import EllipticCurveKit

public final class DefaultZilliqaService: ZilliqaService, ReactiveCompatible {

    public let apiClient: APIClient

    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
}

public extension DefaultZilliqaService {
    convenience init(endpoint: ZilliqaAPIEndpoint) {
        self.init(apiClient: DefaultAPIClient(endpoint: endpoint))
    }
}


public extension DefaultZilliqaService {

    func getNetworkFromAPI(done: @escaping Done<NetworkResponse>) {
        return apiClient.send(request: GetNetworkRequest(), done: done)
    }


    func getBalance(for address: AddressChecksummedConvertible, done: @escaping Done<BalanceResponse>) -> Void {
        return apiClient.send(request: BalanceRequest(address: address), done: done)
    }

    func send(transaction: SignedTransaction, done: @escaping Done<TransactionResponse>) {
        return apiClient.send(request: TransactionRequest(transaction: transaction), done: done)
    }
}
