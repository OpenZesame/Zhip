//
//  Screen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-13.
//

import SwiftUI

struct Screen<Content>: View where Content: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        content().background(Color.appBackground)
    }
}

