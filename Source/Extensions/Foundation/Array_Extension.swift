//
//  Array_Extension.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-12.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

extension Array {
    func mapToVoid() -> [Void] {
        return map { _ in () }
    }
}
