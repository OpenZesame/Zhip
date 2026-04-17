// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine

final class Navigator<NavigationStep> {
    private let navigationSubject = PassthroughSubject<NavigationStep, Never>()

    lazy var navigation: AnyPublisher<NavigationStep, Never> = navigationSubject.eraseToAnyPublisher()
}

extension Navigator {
    func next(_ step: NavigationStep) {
        navigationSubject.send(step)
    }
}
