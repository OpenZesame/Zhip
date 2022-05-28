//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-21.
//

import Foundation
import SwiftUI

public struct ZhipAuroraView: View {
	public init() {}
	
	public var body: some View {
		AuroraView {
			Text("Zhip")
				.font(.zhip.bigBang)
				.foregroundColor(.white)
		}
	}
}


public struct AuroraView<Content: View>: View {
	let content: Content
	public init(@ViewBuilder content: () -> Content) {
		self.content = content()
	}

	private var maxWidth: CGFloat {
		#if os(iOS)
		return UIScreen.main.bounds.width
		#else
		return 300
		#endif
	}
	
	public var body: some View {
		ZStack {
			ParallaxImage(
				back: "Images/Main/BackAurora",
				middle: "Images/Main/MiddleAurora",
				front: "Images/Main/FrontAurora"
			)
			.frame(maxWidth: maxWidth)
			
			content
				.padding()
		}
	}
}
