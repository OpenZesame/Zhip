//
//  RightBarButtonMaking.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

protocol RightBarButtonMaking {
    static var makeRight: BarButton { get }
}

extension RightBarButtonMaking {
    func setRightBarButton(for viewController: AbstractController) {
        viewController.setRightBarButtonUsing(content: Self.makeRight.content)

    }

}

extension AbstractController {
    func setRightBarButtonUsing(content barButtonContent: BarButtonContent) {
        let item = barButtonContent.makeBarButtonItem(target: self.rightBarButtonAbtractTarget, selector: #selector(AbstractTarget.pressed))
        navigationItem.rightBarButtonItem = item
    }
}
