//
//  TermsOfService.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

final class TermsOfService: Scene<TermsOfServiceView> {}

extension TermsOfService: NavigationBarLayoutOwner {
    var navigationBarLayout: NavigationBarLayout {
        return .hidden
    }
}
