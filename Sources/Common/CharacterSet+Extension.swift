//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-02-23.
//

import Foundation
import Zesame

public extension CharacterSet {
    static var hexadecimalDigitsIncluding0x: CharacterSet {
        let afToAF = CharacterSet(charactersIn: "abcdefABCDEF")
        return CharacterSet.decimalDigits
            .union(afToAF)
            .union(CharacterSet(charactersIn: "0x"))
    }
    
    static var bech32IncludingPrefix: CharacterSet {
        
        let lowercase = Bech32.alphabetString.lowercased()
        let uppercase = Bech32.alphabetString.uppercased()
        
        return CharacterSet(charactersIn: lowercase)
            .union(CharacterSet(charactersIn: uppercase))
			.union(CharacterSet(charactersIn: Network.mainnet.bech32Prefix))
    }
    
    static var bech32OrHexIncludingPrefix: CharacterSet {
        return CharacterSet.bech32IncludingPrefix.union(hexadecimalDigitsIncluding0x)
    }
    
    static var decimalWithSeparator: CharacterSet {
        return CharacterSet.decimalDigits
            .union(CharacterSet(charactersIn: Locale.current.decimalSeparatorForSure))
            .union(CharacterSet(charactersIn: "."))
            .union(CharacterSet(charactersIn: ","))
    }
}
