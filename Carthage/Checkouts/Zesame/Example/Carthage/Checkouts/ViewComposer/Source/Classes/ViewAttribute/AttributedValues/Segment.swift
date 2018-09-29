//
//  SegmentContent.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-11.
//
//

import Foundation

public enum SegmentContent {
    case title(String)
    case image(UIImage)
}

//public enum SegmentContent : Int {
//
//
//    case any
//
//    case left // The capped, leftmost segment. Only applies when numSegments > 1.
//
//    case center // Any segment between the left and rightmost segments. Only applies when numSegments > 2.
//
//    case right // The capped,rightmost segment. Only applies when numSegments > 1.
//
//    case alone // The standalone segment, capped on both ends. Only applies when numSegments = 1.
//}

public extension UISegmentedControl {
    
    func insertSegment(_ segment: SegmentContent, at index: Int, animated: Bool = false) {
        switch segment {
        case .title(let title):
            insertSegment(withTitle: title, at: index, animated: animated)
        case .image(let image):
            insertSegment(with: image, at: index, animated: animated)
        }
    }
}

extension Array where Element == SegmentContent {
    func add(to control: UISegmentedControl, animated: Bool = false) {
        for (index, segment) in enumerated() {
            control.insertSegment(segment, at: index, animated: animated)
        }
    }
}
