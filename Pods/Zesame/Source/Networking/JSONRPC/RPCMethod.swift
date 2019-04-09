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

/// JSONRPC method according to [Zilliqa API docs][1]
///
/// [1]: https://apidocs.zilliqa.com/#introduction
public enum RPCMethod {
    case getBalance(AddressChecksummedConvertible)
    case createTransaction(SignedTransaction)
    case getTransaction(TransactionId)
    case getNetworkId
}

public extension RPCMethod {
    
    typealias EncodeValue<K: CodingKey> = (inout KeyedEncodingContainer<K>) throws -> Void
    
    var method: String {
        switch self {
        case .getBalance: return "GetBalance"
        case .createTransaction: return "CreateTransaction"
        case .getTransaction: return "GetTransaction"
        case .getNetworkId: return "GetNetworkId"
        }
    }
    
    func encodeValue<K>(key: K) -> EncodeValue<K>? where K: CodingKey {
        
        func innerEncode<V>(_ value: V) -> EncodeValue<K> where V: Encodable {
            return { keyedEncodingContainer in
                // DO OBSERVE THE ARRAY! `[]`. We MUST put the encodable in an array, since that is how RPC
                // works. Otherwise we will get `INVALID_JSON_REQUEST`
                try keyedEncodingContainer.encode([value], forKey: key)
            }
        }
        
        switch self {
        case .getBalance(let address): return innerEncode(address.checksummedAddress)
        case .createTransaction(let signedTransaction): return innerEncode(signedTransaction)
        case .getTransaction(let txId): return innerEncode(txId)
        case .getNetworkId: return nil
        }
    }
}

public typealias TransactionId = String
