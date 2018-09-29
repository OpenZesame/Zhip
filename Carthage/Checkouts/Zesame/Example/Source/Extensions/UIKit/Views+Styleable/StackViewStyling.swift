//
//  StackViewStyling.swift
//  ZesameiOSExample
//
//  Created by Alexander Cyon on 2018-09-20.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

protocol StackViewStyling: ContentViewProvider {
    var stackViewStyle: UIStackView.Style { get }
}

extension ContentViewProvider where Self: StackViewStyling {
    func makeContentView() -> UIView {
        return UIStackView(style: stackViewStyle)
    }
}
