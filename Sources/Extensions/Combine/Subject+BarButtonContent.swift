// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import Foundation

extension PassthroughSubject where Output == BarButtonContent, Failure == Never {
    func onBarButton(_ predefined: BarButton) {
        send(predefined.content)
    }
}
