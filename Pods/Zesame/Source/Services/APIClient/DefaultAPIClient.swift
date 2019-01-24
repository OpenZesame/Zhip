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

import JSONRPCKit
import APIKit

public final class DefaultAPIClient: APIClient {
    private let queueLabel = "Zesame"
    private let batchFactory = BatchFactory(version: "2.0", idGenerator: NumberIdGenerator())
    public let baseURL: URL
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }

    private lazy var backgroundDispatchQueue = DispatchQueue(label: queueLabel, qos: .userInitiated)
}

public extension DefaultAPIClient {
    convenience init(endpoint: ZilliqaAPIEndpoint) {
        self.init(baseURL: endpoint.baseURL)
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
