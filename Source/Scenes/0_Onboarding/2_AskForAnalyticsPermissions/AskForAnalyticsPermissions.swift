//
//  AskForAnalyticsPermissions.swift
//  Zupreme
//
//  Created by Andrei Radulescu on 09/11/2018.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

final class AskForAnalyticsPermissions: Scene<AskForAnalyticsPermissionsView> {}

extension AskForAnalyticsPermissions: NavigationBarLayoutOwner {
    var navigationBarLayout: NavigationBarLayout {
        return .hidden
    }
}
