//
//  Address.swift
//  Zesame
//
//  Created by Alexander Cyon on 2019-01-12.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

public enum Address: AddressChecksummedConvertible {

    case checksummed(AddressChecksummed)
    case notNecessarilyChecksummed(AddressNotNecessarilyChecksummed)

}
