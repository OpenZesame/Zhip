//
//  DecryptKeystoreToRevealKeyPairViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-19.
//

import Foundation

protocol DecryptKeystoreToRevealKeyPairViewModel: ObservableObject {
    var password: String { get set }
    var isDecrypting: Bool { get set }
    var isPasswordOnValidFormat: Bool { get set }
    func decrypt() async
    var canDecrypt: Bool { get }
}
