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

    private lazy var setPincodeButton = UIButton(type: .custom)
        .withStyle(.primary)
        .titled(normal: €.Button.setPincode)
        .disabled()

    private lazy var removePincodeButton = UIButton(type: .custom)
        .withStyle(.secondary)
        .titled(normal: €.Button.removePincode)
        .disabled()

    private lazy var backupWalletButton = UIButton(type: .custom)
        .withStyle(.primary)
        .titled(normal: €.Button.backupWallet)
        .disabled()

    private lazy var removeWalletButton = UIButton(type: .custom)
        .withStyle(.secondary)
        .titled(normal: €.Button.removeWallet)
        .disabled()

    private lazy var appVersionLabels = TitledValueView(
        title: €.Label.appVersion,
        stackViewStyle: UIStackView.Style(alignment: .center)
    )

    lazy var stackViewStyle: UIStackView.Style = [
        setPincodeButton,
        removePincodeButton,
        backupWalletButton,
        removeWalletButton,
        appVersionLabels,
        .spacer
    ]
}

extension SettingsView: ViewModelled {
    
    typealias ViewModel = SettingsViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.isSetPincodeButtonEnabled     --> setPincodeButton.rx.isEnabled,
            viewModel.isRemovePincodeButtonEnabled  --> removePincodeButton.rx.isEnabled,
            viewModel.appVersion                    --> appVersionLabels

        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            setPincodeTrigger: setPincodeButton.rx.tap.asDriver(),
            removePincodeTrigger: removePincodeButton.rx.tap.asDriver(),
            backupWalletTrigger: backupWalletButton.rx.tap.asDriver(),
            removeWalletTrigger: removeWalletButton.rx.tap.asDriver()
        )
    }
}
