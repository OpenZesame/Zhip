//
//  BackUpRevealedKeyPairViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-19.
//

import Foundation

protocol BackUpRevealedKeyPairViewModel: ObservableObject {
    var displayablePrivateKey: String { get }
    var displayablePublicKey: String { get }
    func copyPrivateKeyToPasteboard()
    func copyPublicKeyToPasteboard()
    var isPresentingDidCopyToPasteboardAlert: Bool { get set }
    func doneBackingUpKeys()
}
