//
//  ParallaxImage.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-13.
//

import SwiftUI

public struct ParallaxImage: View {
    
    private let back: String
    private let middle: String
    private let front: String
	
	public init(
		back: String,
		middle: String,
		front: String
	) {
		self.back = back
		self.middle = middle
		self.front = front
	}
    
    public var body: some View {
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
