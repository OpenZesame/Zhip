//
//  ContentView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-11.
//

import SwiftUI
struct ContentView: View {
    
    @EnvironmentObject private var model: Model
    
    var body: some View {
        if let wallet = model.wallet {
            HomeView()
                .environmentObject(wallet)
        } else {
            SetupWallet()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
