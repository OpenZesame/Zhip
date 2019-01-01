//
//  DefaultAPIClient.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-09-20.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import JSONRPCKit
import APIKit

public enum ZilliqaEnvironment {
    case testnet(Testnet)
    public enum Testnet: String {
        case prod = "https://api.zilliqa.com"
        case staging = "https://staging-api.aws.zilliqa.com"

        var urlString: String {
            return rawValue
        }
    }

    public var baseURL: URL {
        switch self {
        case .testnet(let testnet):
            return URL(string: testnet.urlString)!
        }
    }
}

public final class DefaultAPIClient: APIClient {
    private let queueLabel = "Zesame"
    private let batchFactory = BatchFactory(version: "2.0", idGenerator: NumberIdGenerator())
    public let baseURL: URL
    public init(baseURL: URL = ZilliqaEnvironment.testnet(.prod).baseURL) {
        self.baseURL = baseURL
    }

    private lazy var backgroundDispatchQueue = DispatchQueue(label: queueLabel, qos: .userInitiated)
}

public extension DefaultAPIClient {
    convenience init(environment: ZilliqaEnvironment) {
        self.init(baseURL: environment.baseURL)
    }
}

public extension DefaultAPIClient {

    func send<Request>(request: Request, done: @escaping Done<Request.Response>) where Request: JSONRPCKit.Request {
        let httpRequest = ZilliqaRequest(batch: batchFactory.create(request), baseURL: baseURL)
        let handlerAPIKit = mapHandler(done)

        Session.send(httpRequest, callbackQueue: .dispatchQueue(backgroundDispatchQueue)) {
            assert(!Thread.isMainThread, "Should not be running API calls on the main thread")
            switch $0 {
            case .success(let response): handlerAPIKit(.success(response))
            case .failure(let error): handlerAPIKit(.failure(error))
            }
        }
    }

}
