////
////  HomeView.swift
////  Zhip
////
////  Created by Alexander Cyon on 2022-02-10.
////
//
//import SwiftUI
//
//struct HomeView: View {
//    #if os(iOS)
//    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
//    #endif
//    
//    var body: some View {
//        #if os(iOS)
//        if horizontalSizeClass == .compact {
//            AppTabNavigation()
//        } else {
//            AppSidebarNavigation()
//        }
//        #else
//        AppSidebarNavigation()
//        #endif
//    }
//}
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
