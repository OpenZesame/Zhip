//
//  CallToAction.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-13.
//

import SwiftUI

struct CallToAction<PrimaryView: View, SecondaryView: View>: View {
    
    @ViewBuilder let primary: () -> PrimaryView
    @ViewBuilder let secondary: () -> SecondaryView?
 
    var body: some View {
        VStack {
            primary().buttonStyle(.primary)
            if let secondary = secondary {
                secondary().buttonStyle(.secondary)
            }
        }
        
    }
}

