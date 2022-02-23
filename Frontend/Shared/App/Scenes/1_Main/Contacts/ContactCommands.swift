//
//  ContactCommands.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-11.
//

import SwiftUI

struct ContactCommands: Commands {


    var body: some Commands {
        CommandMenu(Text("Contact", comment: "Menu title for contact-related actions")) {
            AddToContactsButton()//.environmentObject(model)
                .keyboardShortcut("+", modifiers: [.option, .command])
        }
    }
}
