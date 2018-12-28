//
//  Double+Zil_Li_Qa.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public extension Zil.Magnitude {
    var zil: Zil {
        return try! Zil(self)
    }
}

public extension Li.Magnitude {
    var li: Li {
        return try! Li(self)
    }
}

public extension Qa.Magnitude {
    var qa: Qa {
        return try! Qa(self)
    }
}
