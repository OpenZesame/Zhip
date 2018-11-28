//
//  Navigating.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-27.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

protocol Navigating {
    associatedtype NavigationStep
    var navigator: Navigator<NavigationStep> { get }
}
