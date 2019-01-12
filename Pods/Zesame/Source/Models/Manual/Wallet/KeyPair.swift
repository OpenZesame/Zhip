//
//  KeyPair.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-10-07.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import EllipticCurveKit

public typealias Curve = Secp256k1
public typealias KeyPair = EllipticCurveKit.KeyPair<Curve>
public typealias PrivateKey = EllipticCurveKit.PrivateKey<Curve>
public typealias PublicKey = EllipticCurveKit.PublicKey<Curve>
public typealias Signature = EllipticCurveKit.Signature<Curve>
public typealias Signer = EllipticCurveKit.AnyKeySigner<Schnorr<Curve>>

extension EllipticCurveKit.PublicKey: CustomStringConvertible {
    public var description: String {
        return hex.compressed
    }
}
