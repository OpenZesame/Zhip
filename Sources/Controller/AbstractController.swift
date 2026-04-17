// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import UIKit

class AbstractController: UIViewController {
    let rightBarButtonSubject = PassthroughSubject<Void, Never>()
    let leftBarButtonSubject = PassthroughSubject<Void, Never>()
    lazy var rightBarButtonAbstractTarget = AbstractTarget(triggerSubject: rightBarButtonSubject)
    lazy var leftBarButtonAbstractTarget = AbstractTarget(triggerSubject: leftBarButtonSubject)
}

extension AbstractController {
    override var description: String { "\(type(of: self))" }
}
