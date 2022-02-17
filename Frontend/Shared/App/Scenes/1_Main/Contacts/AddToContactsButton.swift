//
//  AddToContactsButton.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-11.
//

import SwiftUI


struct AddToContactsButton: View {
    @EnvironmentObject private var model: Model
    
    var isContact: Bool {
        guard let currentRecipientAddress = model.currentRecipientAddress else { return false }
        return model.isContact(address: currentRecipientAddress)
    }
    
    var body: some View {
        Button(action: toggleContact) {
            if isContact {
                Label {
                    Text("Remove from contacts", comment: "Toolbar button/menu item to remove an address from contacts")
                } icon: {
                    Image(systemName: "heart.fill")
                }
            } else {
                Label {
                    Text("Add to contacts", comment: "Toolbar button/menu item to add an address to contacts")
                } icon: {
                    Image(systemName: "heart")
                }

            }
        }
        .disabled(model.currentRecipientAddress == nil)
    }
    
    func toggleContact() {
        guard let currentRecipientAddress = model.currentRecipientAddress else { return }
        model.toggleContact(address: currentRecipientAddress)
    }
}

struct AddToContactsButton_Previews: PreviewProvider {
    static var previews: some View {
        AddToContactsButton()
            .padding()
            .previewLayout(.sizeThatFits)
            .environmentObject(Model())
    }
}
