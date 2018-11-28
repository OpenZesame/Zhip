//
//  Navigating.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-27.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

/// Type capable of navigating. Declaring which navigation steps it can perform, by
/// declaring an `associatedtype` named `NavigationStep` which typically is a nested
/// enum.
protocol Navigating {
    associatedtype NavigationStep
    var navigator: Navigator<NavigationStep> { get }
}
