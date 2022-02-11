//
//  ZhipApp.swift
//  Shared
//
//  Created by Alexander Cyon on 2022-02-10.
//

import SwiftUI

@main
struct ZhipApp: App {

        @StateObject private var model = Model()
        
        var body: some Scene {
            WindowGroup {
                ContentView()
                    .environmentObject(model)
            }
            .commands {
                SidebarCommands()
                ContactCommands(model: model)
            }
        }
    }
