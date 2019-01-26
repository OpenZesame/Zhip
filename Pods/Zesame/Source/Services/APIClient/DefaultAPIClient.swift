// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
