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

import Foundation

public struct RPCError: Swift.Error, Decodable {
    public let requestId: String
    public let errorMessage: String
    public let errorCode: RPCErrorCode
}

public extension RPCError {
    
    private struct InnerError: Decodable {
        public let code: RPCErrorCode
        public let message: String
    }
    
    enum CodingKeys: String, CodingKey {
        case error
        case requestId = "id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.requestId = try container.decode(String.self, forKey: .requestId)
        let innerError = try container.decode(InnerError.self, forKey: .error)
        self.errorCode = innerError.code
        self.errorMessage = innerError.message
    }
}

public enum RPCErrorCode: Decodable {
    case unrecognizedError(code: Int)
    case failedToParseErrorCode(metaError: Swift.Error)
    case recognizedRPCError(RPCErrorCodeRecognized)
}

public extension RPCErrorCode {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = .recognizedRPCError(try container.decode(RPCErrorCodeRecognized.self))
        } catch {
            do {
                self = .unrecognizedError(code: try container.decode(Int.self))
            } catch let decodeErrorCodeMetaError {
                self = .failedToParseErrorCode(metaError: decodeErrorCodeMetaError)
            }
        }
    }
}

/// Standard JSON-RPC 2.0 errors, as defined by [Zilliqa JS library][1]
/// [1]: https://github.com/Zilliqa/Zilliqa-JavaScript-Library/blob/76fed2012f0f3d6a081402e0c5d3f015ba15a7be/packages/zilliqa-js-core/src/net.ts#L52-L77
public enum RPCErrorCodeRecognized: Int, Decodable, Equatable {
    case invalidRequest = -32600
    case methodNotFound = -32601
    case invalidParams = -32602
    case internalError = -32603
    case parseError = -32700
}
