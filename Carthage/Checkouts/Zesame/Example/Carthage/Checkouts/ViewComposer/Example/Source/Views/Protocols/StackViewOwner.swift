//
//  StackViewOwner.swift
//  Example
//
//  Created by Alexander Cyon on 2017-06-13.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import UIKit

protocol StackViewOwner: SingleSubviewOwner {
    associatedtype StackViewType: UIStackView
    associatedtype SubviewType = StackViewType
    var stackView: StackViewType { get set }
}

extension StackViewOwner where Self.SubviewType == Self.StackViewType {
    var subview: SubviewType {
        get { return stackView }
        set { stackView = newValue }
    }
}
