//
//  View+Extensions.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension View {
  
    @inlinable func frame(
        size: CGFloat,
        alignment: Alignment = .center
    ) -> some View {
        frame(width: size, height: size, alignment: alignment)
    }

}

