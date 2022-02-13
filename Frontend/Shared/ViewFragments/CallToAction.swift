//
//  CallToAction.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-13.
//

import SwiftUI

struct CallToAction<PrimaryLabel: View, SecondaryLabel: View>: View {
    
    @ViewBuilder let primary: () -> Button<PrimaryLabel>
    @ViewBuilder let secondary: () -> Button<SecondaryLabel>?
 
    var body: some View {
        VStack {
            primary().buttonStyle(.primary)
            if let secondary = secondary {
                secondary().buttonStyle(.secondary)
            }
        }
        
    }
}

