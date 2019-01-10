//
//  SettingsView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private typealias € = L10n.Scene.Settings

// MARK: - SettingsView
final class SettingsView: HeaderlessTableView<SettingsTableViewCell>, EmptyInitializable {

    init() {
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }
}

extension SettingsView: ViewModelled {
    typealias ViewModel = SettingsViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.sections.drive(sections),
            viewModel.footerText.drive(rx.footerLabel)
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            selectedIndedPath: rx.itemSelected.asDriver()
        )
    }
}
