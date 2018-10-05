//
//  Scrypt+Parameters.swift
//  Zesame-iOS
//
//  Created by Alexander Cyon on 2018-09-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public extension Scrypt {

    convenience init(kdfParameters: Keystore.Crypto.KeyDerivationFunctionParameters) {
        self.init(params:
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
