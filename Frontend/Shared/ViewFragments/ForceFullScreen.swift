//
//  ForceFullScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-13.
//

import SwiftUI

struct ForceFullScreen<Content>: View where Content: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            Color.appBackground.edgesIgnoringSafeArea(.all)
            content().padding()
        }
    }
}

