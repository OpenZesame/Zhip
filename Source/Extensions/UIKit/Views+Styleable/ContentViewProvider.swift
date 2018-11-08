//
//  StackViewOwningView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

protocol ContentViewProvider {
    func makeContentView() -> UIView
}

extension ContentViewProvider where Self: StackViewStyling {
    func makeContentView() -> UIView {
        return UIStackView(style: stackViewStyle)
    }
}
