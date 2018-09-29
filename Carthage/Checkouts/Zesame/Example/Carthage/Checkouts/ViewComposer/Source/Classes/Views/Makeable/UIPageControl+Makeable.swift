//
//  UIPageControl+Makeable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-13.
//
//

import Foundation

extension UIPageControl: Makeable {
    public typealias StyleType = ViewStyle
    public static func createEmpty() -> UIPageControl {
        return UIPageControl(frame: .zero)
    }
}
