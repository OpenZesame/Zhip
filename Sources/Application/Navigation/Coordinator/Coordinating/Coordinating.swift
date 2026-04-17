// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import UIKit

protocol Coordinating: AnyObject, CustomStringConvertible {
    var childCoordinators: [Coordinating] { get set }
    var cancellables: Set<AnyCancellable> { get set }
    func start(didStart: Completion?)
    var navigationController: UINavigationController { get }
}

extension Coordinating {
    var description: String { stringRepresentation(level: 1) }
}
