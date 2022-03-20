////
////  SettingsScreen.swift
////  Zhip
////
////  Created by Alexander Cyon on 2022-02-10.
////
//
//import SwiftUI
//
//struct SettingsScreen: View {
//    @ObservedObject var viewModel: SettingsViewModel
//    
//    init(viewModel: SettingsViewModel) {
//        self.viewModel = viewModel
//#if os(iOS)
//        UITableView.appearance().backgroundColor = .clear
//        UITableViewHeaderFooterView.appearance().backgroundView = .init()
//#endif
//    }
//}
//
//// MARK: - View
//// MARK: -
//extension SettingsScreen {
//    
//    var body: some View {
//        VStack {
//            choices
//            stickyFooter
//        }
//        .alert(isPresented: $viewModel.isAskingForDeleteWalletConfirmation) {
//            deleteWalletConfirmationAlert
//        }
//    }
//}
//
//// MARK: - Private
//// MARK: -
//private extension SettingsScreen {
//    
//    var choices: some View {
//        // Why not use List?
//        // Well as of 2022-02-28 we cannot really customize the appearance of
//        // a List, especially background color, not the row views
//        // (`UITableViewCell`). But everything just works using a `LazyVStack`
//        // inside a `ScrollView`.
//        ScrollView {
//            LazyVStack(alignment: .leading) {
//                ForEach(viewModel.settingsChoicesSections) { settingsChoicesSection in
//                    
//                    // To be replaced with `Section` in `List` when we can customize
//                    // the background color of List **and** Section.
//                    manualSectionDelimitor
//                    
//                    ForEach(settingsChoicesSection.choices) { settingsChoice in
//                        SettingsChoiceView(settingsChoice: settingsChoice) {
//                            viewModel.userSelected(settingsChoice)
//                        }
//                    }
//                    
//                }
//            }
//            
//        }
//    }
//    
//    var manualSectionDelimitor: some View {
//        Color.clear.frame(width: 10, height: 10, alignment: .center)
//    }
//    
//    var deleteWalletConfirmationAlert: Alert {
//        Alert(
//            title: Text("Really delete wallet?"),
//            message: Text("If you have not backed up your private key elsewhere, you will not be able to restore this wallet. All funds will be lost forever."),
//            primaryButton: .destructive(Text("Delete")) {
//                viewModel.confirmWalletDeletion()
//            },
//            secondaryButton: .cancel()
//        )
//    }
//    
//    var stickyFooter: some View {
//        Text(viewModel.version)
//            .font(.footnote)
//            .foregroundColor(.silverGrey)
//    }
//}
