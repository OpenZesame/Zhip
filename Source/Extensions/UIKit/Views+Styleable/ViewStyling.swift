//
//  ViewStyling.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-14.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

public protocol ViewStyling {
    var height: CGFloat? { get }
    var backgroundColor: UIColor? { get }
}

extension ViewStyling where Self: Makeable, Self.View.Empty == Self.View, Self.View.Style == Self {
    func make() -> View {
        return View(style: self)
    }
}
