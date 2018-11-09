//
//  Receive.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

private typealias € = L10n.Scene.Receive

final class Receive: Scene<ReceiveView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .action, target: rightBarButtonAbtractTarget, action: #selector(AbstractTarget.pressed))
    }
}

extension Receive {
    static let title = €.title
}
