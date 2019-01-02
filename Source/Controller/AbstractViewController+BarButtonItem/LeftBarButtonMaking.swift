//
//  LeftBarButtonMaking.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-18.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

protocol LeftBarButtonContentMaking {
    static var makeLeftContent: BarButtonContent { get }
}

protocol LeftBarButtonMaking: LeftBarButtonContentMaking {
    static var makeLeft: BarButton { get }
}

extension LeftBarButtonMaking {
    static var makeLeftContent: BarButtonContent {
        return makeLeft.content
    }
}

extension LeftBarButtonContentMaking {
    func setLeftBarButton(for viewController: AbstractController) {
        viewController.setLeftBarButtonUsing(content: Self.makeLeftContent)
    }
}
