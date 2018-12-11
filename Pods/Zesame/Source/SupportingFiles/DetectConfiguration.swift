//
//  DetectConfiguration.swift
//  Zesame-iOS
//
//  Created by Alexander Cyon on 2018-12-10.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

// https://stackoverflow.com/a/47443568/1311272
let isDebug: Bool = {
    var isDebug = false
    // function with a side effect and Bool return value that we can pass into assert()
    func set(debug: Bool) -> Bool {
        isDebug = debug
        return isDebug
    }
    // assert:
    // "Condition is only evaluated in playgrounds and -Onone builds."
    // so isDebug is never changed to true in Release builds
    assert(set(debug: true))
    return isDebug
}()
