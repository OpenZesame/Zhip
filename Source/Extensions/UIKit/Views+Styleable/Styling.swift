//
//  Styling.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

public protocol Styling {
    associatedtype Style: ViewStyling
    func apply(style: Style)
}

extension Styling where Self: UIView, Self: StaticEmptyInitializable, Self.Empty == Self {

    init(style: Style) {
        self = Self.createEmpty()
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = style.backgroundColor ?? .white
        if let height = style.height {
            self.height(height)
        }
        apply(style: style)
    }
}

extension Styling where Self: UIView, Self: StaticEmptyInitializable, Self.Empty == Self, Style: ExpressibleByStringLiteral, Self.Style.StringLiteralType == String  {

    public init(stringLiteral value: String) {
        let style = Style.init(stringLiteral: value)
        self = Self.init(style: style)
    }
}
