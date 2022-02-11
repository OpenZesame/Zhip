//
//  TopLevelNavigationItem.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-11.
//

import SwiftUI

enum TopLevelNavigationItem {
    case balances
    case transfer
    case contacts
    case settings
}

extension TopLevelNavigationItem {
    var name: String {
        switch self {
        case .balances: return "Balances"
        case .transfer: return "Transfer"
        case .contacts: return "Contacts"
        case .settings: return "Settings"
        }
    }
    var imageName: String {
        switch self {
        case .balances: return "bitcoinsign.circle"
        case .transfer: return "arrow.up.circle"
        case .contacts: return "heart"
        case .settings: return "gear"
        }
    }
    var label: some View {
        Label(name, systemImage: imageName)
    }
}

