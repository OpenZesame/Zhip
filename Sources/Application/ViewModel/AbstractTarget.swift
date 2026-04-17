// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import Foundation

class AbstractTarget {
    private unowned let triggerSubject: PassthroughSubject<Void, Never>

    init(triggerSubject: PassthroughSubject<Void, Never>) {
        self.triggerSubject = triggerSubject
    }

    @objc func pressed() {
        triggerSubject.send(())
    }
}
