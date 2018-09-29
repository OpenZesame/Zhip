//
//  Radius.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-31.
//
//

import Foundation

public enum CornerRounding {
    case height
    case halfHeight
    case width
    case halfWidth
}

extension CornerRounding {
    func apply(to view: UIView) {
        view.layer.cornerRadius = cornerRadius(for: view)
    }
    
    func cornerRadius(for view: UIView) -> CGFloat {
        let halfHeight: CGFloat = view.bounds.height / 2
        let halfWidth: CGFloat = view.bounds.width / 2
        switch self {
        case .height:
            return halfHeight
        case .halfHeight:
            return halfHeight / 2
        case .width:
            return halfWidth
        case .halfWidth:
            return halfWidth / 2
        }
    }
}
