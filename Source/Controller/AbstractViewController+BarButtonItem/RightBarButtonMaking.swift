//
//  RightBarButtonMaking.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

protocol RightBarButtonContentMaking {
    static var makeRightContent: BarButtonContent { get }
}

protocol RightBarButtonMaking: RightBarButtonContentMaking {
    static var makeRight: BarButton { get }
}

extension RightBarButtonMaking {
    static var makeRightContent: BarButtonContent {
        return makeRight.content
    }
}

extension RightBarButtonContentMaking {
    func setRightBarButton(for viewController: AbstractController) {
        viewController.setRightBarButtonUsing(content: Self.makeRightContent)
    }
}

protocol BackButtonHiding {}
