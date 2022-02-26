//
//  SettingsScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-10.
//

import SwiftUI

struct SettingsScreen: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        #if os(iOS)
        UITableView.appearance().backgroundColor = .clear
        UITableViewHeaderFooterView.appearance().backgroundView = .init()
        #endif
    }
}

struct SettingsChoiceView: View {
    let settingsChoice: SettingsChoice
    let action: () -> Void
    init(settingsChoice: SettingsChoice, action: @escaping () -> Void) {
        self.settingsChoice = settingsChoice
        self.action = action
    }
}
extension SettingsChoiceView {
    var body: some View {
        Button.init(action: {
            action()
        }, label: {
            Label(
                title: { Text(settingsChoice.title).foregroundColor(Color.white) },
                icon: {
                    settingsChoice.icon
                        .foregroundColor(settingsChoice.isDestructive ? Color.bloodRed : Color.turquoise)
                })
                
        })
            .padding()
       
    }
}

// MARK: - View
// MARK: -
extension SettingsScreen {
    
    var manualSectionDelimitor: some View {
        Color.clear.frame(width: 10, height: 10, alignment: .center)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.settingsChoicesSections) { settingsChoicesSection in
                    manualSectionDelimitor
                    ForEach(settingsChoicesSection.choices) { settingsChoice in
                        SettingsChoiceView(settingsChoice: settingsChoice) {
                            viewModel.userSelected(settingsChoice)
                        }
                    }
                }
            }
        }
        .alert(isPresented: $viewModel.isAskingForDeleteWalletConfirmation) {
            Alert(
                title: Text("Really delete wallet?"),
                message: Text("If you have not backed up your private key elsewhere, you will not be able to restore this wallet. All funds will be lost forever."),
                primaryButton: .destructive(Text("Delete")) {
                    viewModel.confirmWalletDeletion()
                },
                secondaryButton: .cancel()
            )
        }
    }
}
