//
//  AbstractCoordinator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-27.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AbstractCoordinator<Step>: Coordinator {

    var childCoordinators = [BaseCoordinator]()
    let stepper = Stepper<Step>()
    let bag = DisposeBag()
    let presenter: Presenter?

    lazy var navigation = stepper.navigation

    // MARK: - Initialization
    init(presenter: Presenter?) {
        self.presenter = presenter
    }

    // MARK: - Overridable
    func start() {
        fatalError("override me")
    }
}
