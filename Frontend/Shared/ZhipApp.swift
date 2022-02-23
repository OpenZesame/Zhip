//
//  ZhipApp.swift
//  Shared
//
//  Created by Alexander Cyon on 2022-02-10.
//

import SwiftUI

import ZhipEngine
import Stinsen

@main
struct ZhipApp: App {
    
//    @StateObject private var model = Model()
    
    init() {
        #if os(iOS)
        // For NavigationBarTitle with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // For NavigationBarTitle with `displayMode = .inline`
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            AppCoordinator(
                useCaseProvider: DefaultUseCaseProvider.shared
            )
                .view()
                .background(Color.appBackground)
                .foregroundColor(.white)
        }
        .commands {
            SidebarCommands()
//            ContactCommands(model: model)
        }
    }
}
