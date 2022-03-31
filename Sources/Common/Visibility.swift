//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-03-31.
//

import SwiftUI

// Inspiration: https://swiftuirecipes.com/blog/how-to-hide-a-swiftui-view-visible-invisible-gone

public enum ViewVisibility: CaseIterable {
	
	/// View is fully visible
	case visible
	
	/// View is hidden but takes up space
	case invisible
	
	/// View is fully removed from the view hierarchy
	case gone
}

public extension View {
	
	@ViewBuilder
	func visibility(_ visibility: ViewVisibility) -> some View {
		switch visibility {
		case .visible:
			self
		case .invisible:
			hidden()
		case .gone:
			EmptyView()
		}
		
	}
}
