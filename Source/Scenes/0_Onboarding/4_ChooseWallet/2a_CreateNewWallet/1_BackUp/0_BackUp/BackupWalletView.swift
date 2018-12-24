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

    private lazy var backUpLabel                    = UILabel()
    private lazy var urgeBackupLabel                = UILabel()

    private lazy var privateKeyLabel                = UILabel()
    private lazy var revealPrivateKeyButton         = UIButton()
    private lazy var privateKeyButtonContainer      = UIStackView(arrangedSubviews: [revealPrivateKeyButton, .spacer])
    private lazy var privateKeyViews                = UIStackView(arrangedSubviews: [privateKeyLabel, privateKeyButtonContainer])

    private lazy var keystoreLabel                  = UILabel()
    private lazy var copyKeystoreButton             = UIButton()
    private lazy var revealKeystoreButton           = UIButton()
    private lazy var keystoreButtons                = UIStackView(arrangedSubviews: [revealKeystoreButton, copyKeystoreButton, .spacer])
    private lazy var keystoreViews                  = UIStackView(arrangedSubviews: [keystoreLabel, keystoreButtons])

    private lazy var understandsRisksCheckbox       = CheckboxWithLabel()
    private lazy var doneButton                     = UIButton()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        backUpLabel,
        urgeBackupLabel,
        privateKeyViews,
        keystoreViews,
        .spacer,
        understandsRisksCheckbox,
        doneButton
    ]

    override func setup() {
        setupSubviews()
    }
}

extension BackupWalletView: ViewModelled {
    typealias ViewModel = BackupWalletViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.isDoneButtonEnabled    --> doneButton.rx.isEnabled
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            copyKeystoreToPasteboardTrigger: copyKeystoreButton.rx.tap.asDriver(),
            revealKeystoreTrigger: revealKeystoreButton.rx.tap.asDriver(),
            revealPrivateKeyTrigger: revealPrivateKeyButton.rx.tap.asDriver(),
            isUnderstandsRiskCheckboxChecked: understandsRisksCheckbox.rx.isChecked.asDriver(),
            doneTrigger: doneButton.rx.tap.asDriver()
        )
    }
}

private typealias € = L10n.Scene.BackupWallet
private extension BackupWalletView {
    // swiftlint:disable:next function_body_length
    func setupSubviews() {

        backUpLabel.withStyle(.header) {
            $0.text(€.Label.backUpKeys)
        }

        urgeBackupLabel.withStyle(.body) {
            $0.text(€.Label.urgeBackup)
        }

        privateKeyLabel.withStyle(.checkbox) {
            $0.text(€.Label.privateKey)
        }

        revealPrivateKeyButton.withStyle(.hollow) {
            $0.title(€.Buttons.reveal)
        }

        privateKeyButtonContainer.withStyle(.horizontal)

        privateKeyViews.withStyle(.vertical)

        keystoreLabel.withStyle(.checkbox) {
            $0.text(€.Label.keystore)
        }

        copyKeystoreButton.withStyle(.hollow) {
            $0.title(€.Button.copy)
        }

        revealKeystoreButton.withStyle(.hollow) {
            $0.title(€.Buttons.reveal)
        }

        keystoreButtons.withStyle(.horizontal)

        keystoreViews.withStyle(.vertical)

        understandsRisksCheckbox.withStyle(.default) {
            $0.text(€.Checkbox.haveSecurelyBackedUp)
        }

        [copyKeystoreButton, revealKeystoreButton, revealPrivateKeyButton].forEach {
            $0.width(136)
        }

        doneButton.withStyle(.primary) {
            $0.title(€.Button.done)
                .disabled()
        }
    }
}
