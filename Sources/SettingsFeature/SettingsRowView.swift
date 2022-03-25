//
//  SettingsChoiceView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-28.
//

import SwiftUI

struct SettingsRowView: View {
    
    let row: Row
    let action: () -> Void
    
    init(row: Row, action: @escaping () -> Void) {
        self.row = row
        self.action = action
    }
}

extension SettingsRowView {
    var body: some View {
        Button(
            action: action,
            label: {
                Label(
                    title: {
                        Text(row.title).foregroundColor(Color.white)
                    },
                    icon: {
						row.icon
                            .foregroundColor(
								row.isDestructive ? .bloodRed : .turquoise
                            )
                    }
                )
        })
        .padding()
       
    }
}
