//
//  InputType.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-14.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

protocol InputType {
    associatedtype FromView
    associatedtype FromController
    var fromView: FromView { get }
    var fromController: FromController { get }
    init(fromView: FromView, fromController: FromController)
}
