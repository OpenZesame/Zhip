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

/// A minimum container of a valid Bech32 address containing the prefix, delimiter, data (relevant information) and checksum
public struct Bech32Address:
    AddressChecksummedConvertible,
    StringConvertible,
    Equatable,
    ExpressibleByStringLiteral
{
    
    public let humanReadablePrefix: String
    public let dataPart: DataPart
    
    init(prefix: String, dataPart: DataPart) {
        self.humanReadablePrefix = prefix
        self.dataPart = dataPart
    }
    
    init(network: Network, dataPart: DataPart) {
        self.init(prefix: network.bech32Prefix, dataPart: dataPart)
    }
}

public extension Bech32Address {
    enum Error: Swift.Error, Equatable {
        case incorrectDataLength(expectedByteCountOf: Int, butGot: Int)
    }
}

public extension Bech32Address {
    
    func toChecksummedLegacyAddress() throws -> LegacyAddress {
        guard let relevantInfoPart = dataPart.excludingChecksum else {
            throw Address.Error.bech32DataEmpty
        }
        
        let expecetedLength = Address.Style.bech32.expectedLength
        let length = relevantInfoPart.asString.count
        guard length == expecetedLength else {
            throw Address.Error.incorrectLength(expectedLength: expecetedLength, forStyle: Address.Style.bech32, butGot: length)
        }
        
        let addressAsData = try Bech32.convertbits(data: relevantInfoPart.data.bytes, fromBits: 5, toBits: 8, pad: false)
        let hexString = try HexString(addressAsData.toHexString())
        let ethStyleNotNecessarilyChecksummed = try LegacyAddress(unvalidatedHex: hexString)
        return try ethStyleNotNecessarilyChecksummed.toChecksummedLegacyAddress()
    }
}



public extension Bech32Address {
    init(prefix: String, unchecksummedData: Data) throws {

        let expectedByteCount = 20
        let byteCount = unchecksummedData.bytes.count
        guard byteCount == expectedByteCount else {
            throw Error.incorrectDataLength(expectedByteCountOf: expectedByteCount, butGot: byteCount)
        }
        let value = try Bech32.convertbits(data: unchecksummedData.bytes, fromBits: 8, toBits: 5, pad: false).asData
        let checksum = Bech32.createChecksum(humanReadablePart: prefix, values: value)
        
        self.init(prefix: prefix, dataPart:
            DataPart(
                dataExcludingChecksum: value,
                checksum: checksum
            )
        )
    }
    

    init(network: Network, unchecksummedData: Data) throws {
        try self.init(prefix: network.bech32Prefix, unchecksummedData: unchecksummedData)
    }

    init(ethStyleAddress address: LegacyAddress, network: Network = .mainnet) throws {

        try self.init(
            network: network,
            unchecksummedData: address.asData
        )
    }
    
    init(ethStyleAddress address: String, network: Network = .mainnet) throws {
        let checksummedAddress = try LegacyAddress(string: address)
        try self.init(ethStyleAddress: checksummedAddress, network: network)
    }
    
    init(bech32String: String) throws {
        self = try Bech32.decode(bech32String)
    }
}

public extension Bech32Address {
    init(stringLiteral bech32String: String) {
        do {
            try self.init(bech32String: bech32String)
        } catch {
           fatalError("Not a valid Bech32 address")
        }
    }
}

public extension Bech32Address {
    struct DataPart: Equatable, CustomStringConvertible {
    
        public let excludingChecksum: Bech32Data?
        public let checksum: Bech32Data
        
        public init(excludingChecksum: Bech32Data?, checksum: Bech32Data) {
            self.excludingChecksum = excludingChecksum
            self.checksum = checksum
        }
    }
}

public extension Bech32Address.DataPart {
    init(dataExcludingChecksum: Data, checksum: Data) {
        self.init(
            excludingChecksum: Bech32Data(dataExcludingChecksum),
            checksum: Bech32Data(checksum)
        )
    }
    
    var includingChecksum: Bech32Data {
        guard let excludingChecksum = excludingChecksum else {
            return checksum
        }
        return Bech32Data(excludingChecksum.data + checksum.data)
    }
    
    var description: String {
        return includingChecksum.description
    }
}

public extension Bech32Address.DataPart {
    struct Bech32Data: Equatable, CustomStringConvertible {
        public let data: Data
        
        public init(_ data: Data) {
            self.data = data
        }
    }
}

public extension Bech32Address.DataPart.Bech32Data {
    var asString: String {
        return Bech32.dataToString(data: data)
    }
    
    var description: String {
        return asString
    }
}

// MARK: - StringConvertible
public extension Bech32Address {
    var asString: String {
        return [
            humanReadablePrefix,
            Bech32.checksumMarker,
            dataPart.description
        ].joined()
    }
}

extension Network {
    var bech32Prefix: String {
        switch self {
        case .testnet:
            return "tzil"
        case .mainnet:
            return "zil"
        }
    }
    
    init(bech32Prefix: String) throws {
        let bech32Prefix = bech32Prefix.lowercased()
        if bech32Prefix == Network.testnet.bech32Prefix {
            self = .testnet
        } else if bech32Prefix == Network.mainnet.bech32Prefix {
            self = .mainnet
        } else {
            throw Bech32Error.unrecognizedBech32Prefix(bech32Prefix)
        }
    }
    
}

public extension Network {
    enum Bech32Error: Swift.Error {
        case unrecognizedBech32Prefix(String)
    }
}
