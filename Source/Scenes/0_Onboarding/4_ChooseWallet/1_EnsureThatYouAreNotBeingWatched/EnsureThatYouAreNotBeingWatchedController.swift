//
//  EnsureThatYouAreNotBeingWatchedController.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-22.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

final class EnsureThatYouAreNotBeingWatched: Scene<EnsureThatYouAreNotBeingWatchedView> {}

extension EnsureThatYouAreNotBeingWatched: LeftBarButtonMaking {
    static let makeLeft: BarButton = .cancel
}

