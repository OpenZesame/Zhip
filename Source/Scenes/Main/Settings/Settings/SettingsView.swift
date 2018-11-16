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

    private lazy var setPincodeButton = UIButton.Style(€.Button.setPincode, textColor: .white, colorNormal: .blue, isEnabled: false).make()
    private lazy var removePincodeButton = UIButton.Style(€.Button.removePincode, colorNormal: .red, isEnabled: false).make()
    private lazy var backupWalletButton = UIButton.Style(€.Button.backupWallet).make()
    private lazy var removeWalletButton = UIButton.Style(€.Button.removeWallet, colorNormal: .red).make()

    private lazy var appVersionLabels = LabelsView(
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
