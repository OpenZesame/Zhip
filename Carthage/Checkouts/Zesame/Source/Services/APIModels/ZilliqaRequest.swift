//
//  ZilliqaRequest.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-09-10.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import JSONRPCKit
import APIKit

public struct ZilliqaRequest<Batch: JSONRPCKit.Batch>: APIKit.Request {
    public typealias Response = Batch.Responses
    public let batch: Batch
}

public extension ZilliqaRequest {
    var baseURL: URL {
        return URL(string: "https://scilla-test-api.aws.z7a.xyz")!
    }

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

        if let jsonString = String(data: jsonData, encoding: .utf8), jsonString.contains("error") {
            print("⚠️ ERROR - json contains word 'error':")
            print(jsonString)
        }

        return try batch.responses(from: jsonData)
    }
}

