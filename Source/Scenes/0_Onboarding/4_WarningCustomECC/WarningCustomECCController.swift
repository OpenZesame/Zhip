//
//  WarningCustomECCController.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-02-08.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import UIKit

final class WarningCustomECC: Scene<WarningCustomECCView>, NavigationBarLayoutOwner {
    let navigationBarLayout: NavigationBarLayout

    init(viewModel: ViewModel, navigationBarLayout: NavigationBarLayout) {
        self.navigationBarLayout = navigationBarLayout
        super.init(viewModel: viewModel)
    }

    required init(viewModel: ViewModel) {
        self.navigationBarLayout = .hidden
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }
}
