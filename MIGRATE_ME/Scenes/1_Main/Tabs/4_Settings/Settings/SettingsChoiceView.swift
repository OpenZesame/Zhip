////
////  SettingsChoiceView.swift
////  Zhip
////
////  Created by Alexander Cyon on 2022-02-28.
////
//
//import SwiftUI
//
//struct SettingsChoiceView: View {
//    
//    let settingsChoice: SettingsChoice
//    let action: () -> Void
//    
//    init(settingsChoice: SettingsChoice, action: @escaping () -> Void) {
//        self.settingsChoice = settingsChoice
//        self.action = action
//    }
//}
//
//extension SettingsChoiceView {
//    var body: some View {
//        Button(
//            action: action,
//            label: {
//                Label(
//                    title: {
//                        Text(settingsChoice.title).foregroundColor(Color.white)
//                    },
//                    icon: {
//                        settingsChoice.icon
//                            .foregroundColor(
//                                settingsChoice.isDestructive ? .bloodRed : .turquoise
//                            )
//                    }
//                )
//        })
//        .padding()
//       
//    }
//}
