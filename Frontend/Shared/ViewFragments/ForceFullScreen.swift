//
//  ForceFullScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-13.
//

import SwiftUI

struct ForceFullScreen<Content>: View where Content: View {
    let content: () -> Content

    var body: some View {
        ZStack {
            Color.deepBlue.edgesIgnoringSafeArea(.all)
            content().padding()
        }
    }
}

