//
//  Array+Extensions.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-21.
//

import Foundation

extension Array {
    func appending(_ element: Element, toCount targetCount: Int) -> Self {
        if count >= targetCount {
            return self
        }
        let suffix = [Element](repeating: element, count: targetCount - count)
        return self + suffix
    }
}
