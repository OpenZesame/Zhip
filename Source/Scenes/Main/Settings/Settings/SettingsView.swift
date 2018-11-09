//
//  SettingsView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private typealias € = L10n.Scene.Settings

// MARK: - SettingsView
final class SettingsView: ScrollingStackView {

    private lazy var removeWalletButton = UIButton.Style(€.Button.removeWallet, colorNormal: .red).make()
    private lazy var backupWalletButton = UIButton.Style(€.Button.backupWallet).make()

    private lazy var appVersionLabels = LabelsView(
        title: €.Label.appVersion,
        stackViewStyle: UIStackView.Style(alignment: .center)
    )

    lazy var stackViewStyle: UIStackView.Style = [
        removeWalletButton,
        appVersionLabels,
        backupWalletButton,
        .spacer
    ]
}

extension SettingsView: ViewModelled {
    
    typealias ViewModel = SettingsViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
        	viewModel.appVersion --> appVersionLabels
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            removeWalletTrigger: removeWalletButton.rx.tap.asDriver(),
            backupWalletTrigger: backupWalletButton.rx.tap.asDriver()
        )
    }
}
