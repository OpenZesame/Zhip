//
//  Settings.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

private typealias € = L10n.Scene.Settings

final class Settings: Scene<SettingsView> {}

extension Settings {
    static let title = €.title
}

extension Settings: RightBarButtonMaking {
    static let makeRight: BarButton = .done
}
