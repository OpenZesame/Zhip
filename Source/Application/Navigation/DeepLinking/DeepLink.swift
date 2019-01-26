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

enum DeepLink {
    case send(TransactionIntent)
}

extension DeepLink {
    var asTransaction: TransactionIntent? {
        switch self {
        case .send(let transaction): return transaction
        }
    }
}

extension DeepLink {
    
    static let scheme: String = "zhip://"

    enum Path: String, CaseIterable {
        case send
    }
}

extension DeepLink {
    enum ParseError: Swift.Error {
        case failedToParse
    }

    init?(url: URL) {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let urlHost = components.host,
            let params = components.queryItems,
            let deepLinkPath = DeepLink.Path(rawValue: urlHost)
            else {
                return nil
        }

        switch deepLinkPath {
        case .send:
            if let transaction = TransactionIntent(queryParameters: params) {
                self = .send(transaction)
            } else {
                return nil
            }
        }
    }
}
