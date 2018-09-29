//
//  DefaultAPIClient.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-09-20.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import JSONRPCKit
import APIKit

public final class DefaultAPIClient: APIClient {
    private let batchFactory = BatchFactory(version: "2.0", idGenerator: NumberIdGenerator())
    public init() {}
}

public extension DefaultAPIClient {

    func send<Request>(request: Request, done: @escaping Done<Request.Response>) where Request: JSONRPCKit.Request {
        let httpRequest = ZilliqaRequest(batch: batchFactory.create(request))
        let handlerAPIKit = mapHandler(done)

        Session.send(httpRequest, callbackQueue: nil) {
            switch $0 {
            case .success(let response): handlerAPIKit(.success(response))
            case .failure(let error): print("⚠️ \(error)"); handlerAPIKit(.failure(error))
            }
        }
    }

}
