//
//  Model.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-10.
//

import Foundation

struct Address: Hashable {}
struct Contact: Hashable {
    let address: Address
    let name: String?
    init(address: Address, name: String? = nil) {
        self.address = address
        self.name = name
    }
}

struct Wallet {}
struct Version {
    let version: String
    let build: String
}

final class Model: ObservableObject {
    @Published var wallet: Wallet?
    
    @Published var currentRecipientAddress: Address?
    @Published var contacts = Set<Contact>()
}

extension Bundle {
    func value<Value>(for key: String) -> Value? {
        object(forInfoDictionaryKey: key) as? Value
    }
}

extension Model {
    
    var version: Version {
        let bundle = Bundle.main
        
        let version: String = bundle.value(for: "CFBundleShortVersionString") ?? "1.0"
        let build: String = bundle.value(for: "CFBundleVersion") ?? "1"
        
        return Version(version: version, build: build)
    }
    
    func toggleContact(address: Address) {
        if let contactIndex = contacts.firstIndex(where: { $0.address == address }) {
            contacts.remove(at: contactIndex)
        } else {
            contacts.insert(.init(address: address))
        }
    }
    
    func isContact(address: Address) -> Bool {
        contacts.contains(where: { $0.address == address })
    }
}
