//
//  BackupWalletView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

private typealias € = L10n.Scene.BackupWallet

final class BackupWalletView: ScrollingStackView {

    private lazy var beSafeLabel = UILabel.Style(€.Label.storeKeystoreSecurely, font: UIFont.Label.title, numberOfLines: 0).make()
    private lazy var keystoreTextView = ScrollableContentSizedTextView(style: UITextView.Style(font: .tiny, isEditable: false))

    private lazy var copyKeystoreButton = UIButton(type: .custom)
        .withStyle(.primary)
        .titled(normal: €.Button.copyKeystore)

    private lazy var urgeUserToSecurlyBackupPassphraseLabel = UILabel.Style(€.Label.urgeSecureBackupOfKeystore, numberOfLines: 0).make()

    private lazy var understandsRisksSwitch = UISwitch()
    private lazy var understandsRisksShortLabel = UILabel.Style(€.SwitchLabel.keystoreIsBackedUp).make()
    private lazy var riskStackView = UIStackView.Style([understandsRisksSwitch, understandsRisksShortLabel], axis: .horizontal, margin: 0).make()

    private lazy var haveBackedUpProceedButton = UIButton(type: .custom)
        .withStyle(.secondary)
        .titled(normal: €.Button.haveBackedUpProceed)
        .disabled()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        beSafeLabel,
        keystoreTextView,
        copyKeystoreButton,
        urgeUserToSecurlyBackupPassphraseLabel,
        riskStackView,
        haveBackedUpProceedButton,
        .spacer
    ]

    override func setup() {
        understandsRisksSwitch.translatesAutoresizingMaskIntoConstraints = false
        keystoreTextView.addBorder()
    }
}

extension BackupWalletView: ViewModelled {
    typealias ViewModel = BackupWalletViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.keystoreText              --> keystoreTextView,
            viewModel.isProceedButtonEnabled    --> haveBackedUpProceedButton.rx.isEnabled
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            copyKeystoreToPasteboardTrigger: copyKeystoreButton.rx.tap.asDriver(),
            understandsRisk: understandsRisksSwitch.rx.isOn.asDriver(),
            proceedTrigger: haveBackedUpProceedButton.rx.tap.asDriver()
        )
    }
}
