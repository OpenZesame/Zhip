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
import JSONRPCKit
import APIKit

public struct ZilliqaRequest<Batch: JSONRPCKit.Batch>: APIKit.Request {
    public typealias Response = Batch.Responses
    public let batch: Batch
    public let baseURL: URL
    public init(batch: Batch, baseURL: URL) {
        self.batch = batch
        self.baseURL = baseURL
    }
}

public extension ZilliqaRequest {
    var method: HTTPMethod {
        return .post
    }

    var path: String {
        return "/"
    }

    var headerFields: [String: String] {
        return ["Content-Type": "application/json"]
    }

    var parameters: Any? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(batch) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: [])
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        let jsonData = try JSONSerialization.data(withJSONObject: object)
        return try batch.responses(from: jsonData)
    }
}

