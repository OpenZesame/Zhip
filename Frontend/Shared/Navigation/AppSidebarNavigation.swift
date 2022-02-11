//
//  AppSidebarNavigation.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-10.
//

import SwiftUI
import ZhipEngine

struct AppSidebarNavigation: View {

    @EnvironmentObject private var model: Model
    @EnvironmentObject private var wallet: Wallet
    @State private var selection: TopLevelNavigationItem? = .balances
    
    var body: some View {
        NavigationView {
            List {
                navigationLink(tag: .balances) { Balances() }
                navigationLink(tag: .transfer) { Transfer() }
                navigationLink(tag: .contacts) { Contacts() }
                navigationLink(tag: .settings) { Settings() }
            }
            .navigationTitle("Wallet: \(wallet.name)")
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Text("Version: \(model.version.version) (#\(model.version.build))")
            }
            
            Text("Select a category") // Balances, Contacts, Transfer, Settings
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background()
                .ignoresSafeArea()
            
            Text("Select a view")
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background()
                .ignoresSafeArea()
                .toolbar {
                    AddToContactsButton()
                        .environmentObject(model)
                        .disabled(true)
                }
        }
    }
    
}

extension AppSidebarNavigation {
    
    func navigationLink<Destination: View>(
        tag: TopLevelNavigationItem,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        navigationLink(tag: tag, destination: destination) {
            tag.label
        }
    }
    
    func navigationLink<Label: View, Destination: View>(
        tag: TopLevelNavigationItem,
        @ViewBuilder destination: () -> Destination,
        @ViewBuilder label: () -> Label
    ) -> some View {
        NavigationLink(
            tag: tag,
            selection: $selection,
            destination: destination,
            label: label
        )
    }
}

struct AppSidebarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppSidebarNavigation()
            .environmentObject(Model())
    }
}
