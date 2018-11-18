//
//  AbstractController+BarButtonContent.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-18.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

extension AbstractController {
    func setRightBarButtonUsing(content barButtonContent: BarButtonContent) {
        let item = barButtonContent.makeBarButtonItem(target: self.rightBarButtonAbtractTarget, selector: #selector(AbstractTarget.pressed))
        navigationItem.rightBarButtonItem = item
    }

    func setLeftBarButtonUsing(content barButtonContent: BarButtonContent) {
        let item = barButtonContent.makeBarButtonItem(target: self.leftBarButtonAbtractTarget, selector: #selector(AbstractTarget.pressed))
        navigationItem.leftBarButtonItem = item
    }
}

