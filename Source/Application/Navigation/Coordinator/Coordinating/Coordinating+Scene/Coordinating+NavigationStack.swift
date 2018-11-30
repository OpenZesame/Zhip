//
//  Coordinating+NavigationStack.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

extension Coordinating {
    func isTopmost<Scene>(scene: Scene.Type) -> Bool where Scene: UIViewController {
        guard navigationController.topViewController is Scene else { return false }
        return true
    }
}
