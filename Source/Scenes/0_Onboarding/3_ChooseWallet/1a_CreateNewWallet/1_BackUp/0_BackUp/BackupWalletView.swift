//
//  BackupWalletView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

final class BackupWalletView: ScrollingStackView {

    private lazy var beSafeLabel = UILabel()

    private lazy var copyKeystoreButton = UIButton()

    private lazy var revealKeystoreButton = UIButton()

    private lazy var keystoreButtons = UIStackView(arrangedSubviews: [copyKeystoreButton, revealKeystoreButton])

    private lazy var revealPrivateKeyButton = UIButton()

    private lazy var urgeUserToSecurlyBackupPassphraseLabel = UILabel()

    private lazy var understandsRisksCheckbox = CheckboxWithLabel()

    private lazy var haveBackedUpProceedButton = UIButton()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        beSafeLabel,
        keystoreButtons,
        revealPrivateKeyButton,
        urgeUserToSecurlyBackupPassphraseLabel,
        understandsRisksCheckbox,
        haveBackedUpProceedButton,
        .spacer
    ]

    override func setup() {
        setupSubviews()
    }
}

extension BackupWalletView: ViewModelled {
    typealias ViewModel = BackupWalletViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.isProceedButtonEnabled    --> haveBackedUpProceedButton.rx.isEnabled
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            copyKeystoreToPasteboardTrigger: copyKeystoreButton.rx.tap.asDriver(),
            revealKeystoreTrigger: revealKeystoreButton.rx.tap.asDriver(),
            revealPrivateKeyTrigger: revealPrivateKeyButton.rx.tap.asDriver(),
            isUnderstandsRiskCheckboxChecked: understandsRisksCheckbox.rx.isChecked.asDriver(),
            proceedTrigger: haveBackedUpProceedButton.rx.tap.asDriver()
        )
    }
}

private typealias € = L10n.Scene.BackupWallet
private extension BackupWalletView {
    func setupSubviews() {
        beSafeLabel.withStyle(.header) {
            $0.text(€.Label.storeKeystoreSecurely)
        }

        copyKeystoreButton.withStyle(.primary) {
            $0.title(€.Button.copyKeystore)
        }

        revealKeystoreButton.withStyle(.secondary) {
            $0.title(€.Button.revealKeystore)
        }

        keystoreButtons.withStyle(.horizontal)

        revealPrivateKeyButton.withStyle(.secondary) {
            $0.title(€.Button.revealPrivateKey)
        }

        urgeUserToSecurlyBackupPassphraseLabel.withStyle(.body) {
            $0.text(€.Label.urgeSecureBackupOfKeystore)
        }

        understandsRisksCheckbox.withStyle(.default) {
            $0.text(€.Checkbox.keystoreIsBackedUp)
        }

        haveBackedUpProceedButton.withStyle(.secondary) {
            $0.title(€.Button.haveBackedUpProceed)
                .disabled()
        }
    }
}
