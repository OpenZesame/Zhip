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

public enum Address:
    AddressChecksummedConvertible,
    StringConvertible,
    Equatable,
    ExpressibleByStringLiteral
{

    case legacy(LegacyAddress)
    case bech32(Bech32Address)

}

public extension Address {
    
    init(string: String) throws {
        
        do {
            self = .bech32(try Bech32Address(bech32String: string))
        } catch let bech32Error as Bech32.DecodingError {
            let hexString: HexString
            do {
                hexString = try HexString(string)
            } catch {
                throw Address.Error.invalidBech32Address(bechError: bech32Error)
            }
            self = .legacy(try LegacyAddress(hexString: hexString))
        } catch {
            fatalError("Incorrect implementation, expected error of type Bech32.DecodingError, but got: \(error) of type: \(type(of: error))")
        }
    }
}

// MARK: - AddressChecksummedConvertible
public extension Address {
    func toChecksummedLegacyAddress() throws -> LegacyAddress {
        switch self {
        case .bech32(let bech32): return try bech32.toChecksummedLegacyAddress()
        case .legacy(let legacy): return try legacy.toChecksummedLegacyAddress()
        }
    }
}

// MARK: - StringConvertible
public extension Address {
    var asString: String {
        switch self {
        case .bech32(let bech32): return bech32.asString
        case .legacy(let legacy): return legacy.asString
        }
    }
}

public extension Address {
    static func == (lhs: Address, rhs: Address) -> Bool {
        do {
            return try lhs.toChecksummedLegacyAddress() == rhs.toChecksummedLegacyAddress()
        } catch {
            return false
        }
    }
}
