//
//  AddressChecksummedConvertible.swift
//  Zesame
//
//  Created by Alexander Cyon on 2019-01-12.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation
import EllipticCurveKit

public protocol AddressChecksummedConvertible: HexStringConvertible {
    var checksummedAddress: AddressChecksummed { get }
    init(hexString: HexStringConvertible) throws
}
