//
//  ActivityIndicator.swift
//  Zhip
//
//  Originall created by KitKit@stackoverflow on 2019-12-04
//  Profile: https://stackoverflow.com/users/7155095/kitkit
//  Source: https://stackoverflow.com/a/59171234/1311272
//
//  Modified by Alexander Cyon on 2022-02-18.
//

import SwiftUI

public struct ActivityIndicator: View {
    @State private var isAnimating: Bool = false
    public init() {}
}

public extension ActivityIndicator {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<5) { index in
                Group {
                    Circle()
                        .frame(
                            width: geometry.size.width / 5,
                            height: geometry.size.height / 5
                        )
                        .scaleEffect(calculateScale(index: index))
                        .offset(y: calculateYOffset(geometry))
                }.frame(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
                    .rotationEffect(
                        isAnimating
                        ? .degrees(360)
                        : .degrees(0)
                    )
                    .animation(
                        Animation
                            .timingCurve(
                                0.5, 0.15 + Double(index) / 5, 0.25,
                                1,
                                duration: 1.5
                            )
                            .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            isAnimating = true
        }
    }
}

private extension ActivityIndicator {
    func calculateScale(index: Int) -> CGFloat {
        isAnimating
        ? 0.2 + CGFloat(index) / 5
        : 1 - CGFloat(Float(index)) / 5
    }
    
    func calculateYOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.size.width / 10 - geometry.size.height / 2
    }
    
}
