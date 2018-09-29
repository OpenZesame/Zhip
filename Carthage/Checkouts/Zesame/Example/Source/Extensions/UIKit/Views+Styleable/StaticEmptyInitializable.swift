//
//  StaticEmptyInitializable.swift
//  ZesameiOSExample
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public protocol StaticEmptyInitializable {
    associatedtype Empty
    static func createEmpty() -> Empty
}
