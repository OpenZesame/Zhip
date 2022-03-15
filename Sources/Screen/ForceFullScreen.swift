//
//  ForceFullScreen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-13.
//

import SwiftUI

public struct ForceFullScreen<Content>: View where Content: View {
	
	// Could also be saved as function `() -> Content`, but evaluating closure
	// inside init and storing as value seems to be best choice:
	// https://github.com/pointfreeco/swift-composable-architecture/issues/1022#issuecomment-1067816722
	private let content: Content
	
	public init(
		@ViewBuilder content: @escaping () -> Content
	) {
		self.content = content()
	}
	
    public var body: some View {
        ZStack {
            Color.appBackground.edgesIgnoringSafeArea(.all)
            content.padding()
        }
    }
}

