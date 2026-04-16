//
//  WarningCustomECCController.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-02-08.
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
//

import UIKit

final class WarningCustomECC: Scene<WarningCustomECCView>, NavigationBarLayoutOwner {
    let navigationBarLayout: NavigationBarLayout

    init(viewModel: ViewModel, navigationBarLayout: NavigationBarLayout) {
        self.navigationBarLayout = navigationBarLayout
        super.init(viewModel: viewModel)
    }

    required init(viewModel: ViewModel) {
        navigationBarLayout = .hidden
        super.init(viewModel: viewModel)
    }

    required init?(coder _: NSCoder) {
        interfaceBuilderSucks
    }
}
