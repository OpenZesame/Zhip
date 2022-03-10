//
//  CallToAction.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-13.
//

import SwiftUI

public struct CallToAction<PrimaryView: View, SecondaryView: View>: View {
    
    @ViewBuilder public var primary: () -> PrimaryView
    @ViewBuilder public var secondary: () -> SecondaryView?
	
	public init(
		primary: @escaping () -> PrimaryView,
		secondary: @escaping () -> SecondaryView?
	) {
		self.primary = primary
		self.secondary = secondary
	}
 
    public var body: some View {
        VStack {
            primary().buttonStyle(.primary)
            if let secondary = secondary {
                secondary().buttonStyle(.secondary)
            }
        }
        
    }
}

