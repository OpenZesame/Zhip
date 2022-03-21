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
		ZStack {
			ParallaxImage(
				back: "Images/Main/BackAurora",
				middle: "Images/Main/MiddleAurora",
				front: "Images/Main/FrontAurora"
			)
			
			Text("Zhip")
				.font(.zhip.bigBang)
				.foregroundColor(.white)
		}
	}
}
