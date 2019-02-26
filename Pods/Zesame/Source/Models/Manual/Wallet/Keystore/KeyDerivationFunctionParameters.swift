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
import EllipticCurveKit

public typealias KDFParams = KDF.Parameters

public extension KDF {
    public struct Parameters: Codable, Equatable {
        /// "N", CPU/memory cost parameter, must be power of 2.
        let costParameter: Int

        /// "r", blocksize
        let blockSize: Int

        /// "p"
        let parallelizationParameter: Int

        /// "dklen"
        let lengthOfDerivedKey: Int

        let salt: Data

        init(
            costParameter: Int,
            blockSize: Int = 8,
            parallelizationParameter: Int = 1,
            lengthOfDerivedKey: Int = 32,
            salt: Data? = nil
            ) {
            self.costParameter = costParameter
            self.blockSize = blockSize
            self.parallelizationParameter = parallelizationParameter
            self.lengthOfDerivedKey = lengthOfDerivedKey
            self.salt = salt ?? (try! securelyGenerateBytes(count: 32).asData)
        }
    }
}

extension KDFParams {
    enum CodingKeys: String, CodingKey {
        /// Should be lowercase "n", since that is what Zilliqa JS SDK uses
        case costParameter = "n"
        case blockSize = "r"
        case parallelizationParameter = "p"
        case lengthOfDerivedKey = "dklen"

        case salt = "salt"
    }
}
