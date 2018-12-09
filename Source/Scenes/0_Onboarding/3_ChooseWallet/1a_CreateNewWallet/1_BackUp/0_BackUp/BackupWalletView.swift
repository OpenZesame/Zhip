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

extension UILabel {
    convenience init(text: CustomStringConvertible?) {
        self.init(frame: .zero)
        self.text = text?.description
    }
}

final class BackupWalletView: ScrollingStackView {

    private lazy var beSafeLabel = UILabel(text: €.Label.storeKeystoreSecurely).withStyle(.title)

    private lazy var copyKeystoreButton = UIButton(title: €.Button.copyKeystore)
        .withStyle(.primary)

    private lazy var revealKeystoreButton = UIButton(title: €.Button.revealKeystore)
        .withStyle(.secondary)

    private lazy var keystoreButtons = UIStackView(arrangedSubviews: [copyKeystoreButton, revealKeystoreButton])
        .withStyle(.horizontal)

    private lazy var revealPrivateKeyButton = UIButton(title: €.Button.revealPrivateKey)
        .withStyle(.secondary)

    private lazy var urgeUserToSecurlyBackupPassphraseLabel = UILabel(text: €.Label.urgeSecureBackupOfKeystore)
        .withStyle(.body)

    private lazy var understandsRisksCheckbox = CheckboxWithLabel(titled: €.Checkbox.keystoreIsBackedUp)

    private lazy var haveBackedUpProceedButton = UIButton(title: €.Button.haveBackedUpProceed)
        .withStyle(.secondary)
        .disabled()

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
