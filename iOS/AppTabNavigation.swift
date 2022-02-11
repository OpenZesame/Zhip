//
//  AppTabNavigation.swift
//  Zhip (iOS)
//
//  Created by Alexander Cyon on 2022-02-10.
//

import SwiftUI

struct AppTabNavigation: View {

    @State private var selection: TopLevelNavigationItem = .balances

    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                Balances()
            }
            .tabItem {
                TopLevelNavigationItem.balances.label
            }
            .tag(TopLevelNavigationItem.balances)
            
            NavigationView {
                Transfer()
            }
            .tabItem {
                TopLevelNavigationItem.transfer.label
            }
            .tag(TopLevelNavigationItem.transfer)
            
            NavigationView {
                Contacts()
            }
            .tabItem {
                TopLevelNavigationItem.contacts.label
            }
            .tag(TopLevelNavigationItem.contacts)
            
            NavigationView {
                Settings()
            }
            .tabItem {
                TopLevelNavigationItem.settings.label
            }
            .tag(TopLevelNavigationItem.settings)
        }
    }
}

struct AppTabNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppTabNavigation()
    }
}
