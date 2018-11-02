//
//  Navigatable.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-27.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxCocoa

protocol BaseNavigatable {}
protocol Navigatable: BaseNavigatable {
    associatedtype Step
    var stepper: Stepper<Step> { get }
}

extension Navigatable {
    var navigation: Driver<Step> { return stepper.navigationSteps }
}
