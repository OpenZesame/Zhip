//
//  KeyRestoration.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

enum KeyRestoration {
    case privateKey(hexString: String)
    // In the future we will add support for mneumonic and keystores
    //    case mneumonic(Mneumonic)
    //    case keystore(KeyStore, passphrase: String)
}
