//
//  ShakeEffect.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-03-05.
//

import SwiftUI

public struct ShakeEffect: GeometryEffect {
    private(set) var x: CGFloat
   
    public init(x: CGFloat) {
        self.x = x
    }
 
}

// MARK: - GeometryEffect
// MARK: -
public extension ShakeEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: x, y: 0))
    }
}

// MARK: - Animatable
// MARK: -
public extension ShakeEffect {
    var animatableData: CGFloat {
        get { x }
        set { x = newValue }
    }
}
