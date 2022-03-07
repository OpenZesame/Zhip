//
//  ParallaxImage.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-13.
//

import SwiftUI

struct ParallaxImage: View {
    
    let back: String
    let middle: String
    let front: String
    
    var body: some View {
        ZStack {
            image(\.back)
            image(\.middle)
            image(\.front)
        }
        
    }
    
    @ViewBuilder
    private func image(_ keyPath: KeyPath<Self, String>) -> some View {
        Image(self[keyPath: keyPath])
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
}
