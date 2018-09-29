//
//  Scrypt.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-09-23.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import CryptoSwift
import EllipticCurveKit

/// https://tools.ietf.org/html/rfc7914.html
public struct Scrypt {
    private let passphrase: String
    private let parameters: Parameters

    init(passphrase: String, parameters: Parameters) {
        self.passphrase = passphrase
        self.parameters = parameters
    }
}

public extension Scrypt {

    init(passphrase: String, kdfParameters: Keystore.Crypto.KeyDerivationFunctionParameters) {
        self.init(passphrase: passphrase, parameters:
            Parameters(
                costParameter: kdfParameters.costParameter,
                blockSize: kdfParameters.blockSize,
                parallelizationParameter: kdfParameters.parallelizationParameter,
                lengthOfDerivedKey: kdfParameters.lengthOfDerivedKey,
                salt: kdfParameters.salt
            )
        )
    }
}

/// https://tools.ietf.org/html/rfc7914.html
public extension Scrypt {
    public struct Parameters {
        /// "N", CPU/memory cost parameter, must be power of 2.
        let costParameter: Int

        /// "r", blocksize
        let blockSize: Int

        /// "p"
        let parallelizationParameter: Int

        /// "dklen"
        let lengthOfDerivedKey: Int

        let salt: Data
    }
}

public extension Scrypt {

    public enum Error: Swift.Error {
        case r_Negative
        case r_multibliedBy_p_tooLarge
        case r_tooLarge
        case N_tooLarge
    }

    /// `scryptBlockMix` algoritm according to RFC-7914
    /// Reference: https://tools.ietf.org/html/rfc7914.html#section-4
    ///   The scryptBlockMix algorithm is the same as the BlockMix algorithm
    ///   described in *SCRYPT* but with Salsa20/8 Core used as the hash
    ///   function H.  Below, Salsa(T) corresponds to the Salsa20/8 Core
    ///   function applied to the octet vector T.
    ///
    ///    *SCRYPT*: Percival, C., "STRONGER KEY DERIVATION VIA SEQUENTIAL
    ///           MEMORY-HARD FUNCTIONS",  BSDCan'09, May 2009,
    ///           <http://www.tarsnap.com/scrypt/scrypt.pdf>.
    ///
    ///   Algorithm scryptBlockMix
    ///
    ///   Parameters:
    ///            r       Block size parameter.
    ///
    ///   Input:
    ///            B[0] || B[1] || ... || B[2 * r - 1]
    ///                   Input octet string (of size 128 * r octets),
    ///                   treated as 2 * r 64-octet blocks,
    ///                   where each element in B is a 64-octet block.
    ///
    ///   Output:
    ///            B'[0] || B'[1] || ... || B'[2 * r - 1]
    ///                   Output octet string.
    ///
    func scryptBlockMix(bytes B: [Byte]) -> [Byte] {
        fatalError()
    }

    /// The scryptROMix Algorithm, according to RFC-7914
    /// Reference: https://tools.ietf.org/html/rfc7914.html#section-5
    ///
    ///    The scryptROMix algorithm is the same as the ROMix algorithm
    ///    described in *SCRYPT* but with scryptBlockMix used as the hash
    ///    function H and the Integerify function explained inline.
    ///
    ///    *SCRYPT*: Percival, C., "STRONGER KEY DERIVATION VIA SEQUENTIAL
    ///           MEMORY-HARD FUNCTIONS",  BSDCan'09, May 2009,
    ///           <http://www.tarsnap.com/scrypt/scrypt.pdf>.
    ///
    ///    Algorithm scryptROMix
    ///
    ///    Input:
    ///             r       Block size parameter.
    ///             B       Input octet vector of length 128 * r octets.
    ///             N       CPU/Memory cost parameter, must be larger than 1,
    ///                     a power of 2, and less than 2^(128 * r / 8).
    ///
    ///    Output:
    ///             B'      Output octet vector of length 128 * r octets.
    ///
    func scryptROMix(bytes B: [Byte]) -> [Byte] {

        let r = Number(parameters.blockSize)
        let N = Number(parameters.costParameter)

        /// Step 1
        var X = B

        /// Step 2
        var V = [[Byte]]()
        for _ in 0..<N {
            V.append(X)
            X = scryptBlockMix(bytes: X)
        }

        /// Step 3
        for i in 0..<N {
            let Xn = X.asNumber
            let j = Xn.modulus(N)
        }

        fatalError()
    }

    /// Derive key from input, according to RFC-7914
    /// Reference: https://tools.ietf.org/html/rfc7914.html#section-6
    ///
    /// Algorithm scrypt
    ///
    ///    Input:
    ///             P       Passphrase, an octet string.
    ///             S       Salt, an octet string.
    ///             N       CPU/Memory cost parameter, must be larger than 1,
    ///                     a power of 2, and less than 2^(128 * r / 8).
    ///             r       Block size parameter.
    ///             p       Parallelization parameter, a positive integer
    ///                     less than or equal to ((2^32-1) * hLen) / MFLen
    ///                     where hLen is 32 and MFlen is 128 * r.
    ///             dkLen   Intended output length in octets of the derived
    ///                     key; a positive integer less than or equal to
    ///                     (2^32 - 1) * hLen where hLen is 32.
    ///
    ///    Output:
    ///             DK      Derived key, of length dkLen octets.
    ///
    func deriveKey(done: @escaping (DerivedKey) -> Void) throws {
        /// Derived Key Length in bytes
        let dkLen: Int = parameters.lengthOfDerivedKey
        /// Derived Key
        let DK: DataConvertible
        defer { precondition(DK.byteCount == dkLen) }
        let P: DataConvertible = passphrase.data(using: .utf8)!
        let S: DataConvertible = parameters.salt
        let N: Int = parameters.costParameter
        let r: Int = parameters.blockSize
        let p: Int = parameters.parallelizationParameter

        // Functions
        func PBKDF2_HMAC_SHA256(salt: DataConvertible, keyLength: Int) -> [Byte] {

            let result = try! CryptoSwift.PKCS5.PBKDF2(
                password: P.bytes,
                salt: salt.bytes,
                iterations: 1,
                keyLength: keyLength,
                variant: .sha256
            )
            .calculate()

            return result
        }

        /// Step 1: Initialize an array B consisting of p blocks of 128 * r octets each
        var B: [Byte] = PBKDF2_HMAC_SHA256(salt: S, keyLength: p * 128 * r)

        func scryptROMix_() -> [Byte] {
            return scryptROMix(bytes: B)
        }

        /// Step 2
        B = scryptROMix_()

        /// Step 3
        DK = PBKDF2_HMAC_SHA256(salt: B, keyLength: dkLen)

        done(DerivedKey(data: DK, parametersUsed: parameters))
    }
}

public struct DerivedKey {
    public let data: Data
    public let parametersUsed: Scrypt.Parameters
    fileprivate init(data: DataConvertible, parametersUsed: Scrypt.Parameters) {
        self.data = data.asData
        self.parametersUsed = parametersUsed
    }
}

extension DerivedKey: DataConvertible {}
public extension DerivedKey {
    var asData: Data {
        return data
    }
}
