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
import Alamofire

public final class DefaultAPIClient: APIClient, RequestInterceptor {
    
    public let baseURL: URL
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
}

public extension DefaultAPIClient {
    convenience init(endpoint: ZilliqaAPIEndpoint) {
        self.init(baseURL: endpoint.baseURL)
    }
}

// MARK: - RequestInterceptor (RequestAdapter)
public extension DefaultAPIClient {
    func adapt(_ urlRequest: URLRequest, for session: Alamofire.Session, completion: @escaping (Alamofire.AFResult<URLRequest>) -> Void) {
        var urlRequest = urlRequest
        if urlRequest.url?.absoluteString.isEmpty == true || urlRequest.url?.absoluteString == "/" {
            urlRequest.url = baseURL
        }
        completion(Alamofire.AFResult.success(urlRequest))
    }
}

// MARK: - APIClient
public extension DefaultAPIClient {
    
    func send<ResultFromResponse>(method: RPCMethod, done: @escaping Done<ResultFromResponse>) where ResultFromResponse: Decodable {
        let rpcRequest = RPCRequest(method: method)
        Alamofire.Session.default
            .request(rpcRequest, interceptor: self)
            .validate()
            .responseDecodable { (response: DataResponse<RPCResponse<ResultFromResponse>>) in
            switch response.result {
            case .success(let successOrRPCError):
                switch successOrRPCError {
                case .rpcError(let rpcErrorOrDecodeToRPCErrorMetaError): done(Swift.Result.failure(.api(.request(rpcErrorOrDecodeToRPCErrorMetaError))))
                case .rpcSuccess(let resultFromResponse): done(Swift.Result.success(resultFromResponse))
                }
            case .failure(let error): done(Swift.Result.failure(.api(.request(error))))
            }
        }
    }
}
