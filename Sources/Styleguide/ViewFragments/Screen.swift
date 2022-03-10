//
//  Screen.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-13.
//

import SwiftUI

public struct Screen<Content>: View where Content: View {
    @ViewBuilder public var content: () -> Content
	
	public init(content: @escaping () -> Content) {
		self.content = content
	}

    public var body: some View {
        content().background(Color.appBackground)
    }
}

