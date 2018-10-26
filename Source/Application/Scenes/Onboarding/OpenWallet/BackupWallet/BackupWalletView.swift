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

    private lazy var beSafeLabel = UILabel.Style("Store the keystore + passphrase somewhere safe (e.g. 1Password)", font: .boldSystemFont(ofSize: 18), numberOfLines: 0).make()
    private lazy var keystoreTextView = ScrollableContentSizedTextView(style: UITextView.Style(font: .systemFont(ofSize: 10), isEditable: false))
    private lazy var copyKeystoreButton = UIButton.Style("Copy keystore", textColor: .white, colorNormal: .blue).make()

    private lazy var urgeUserToSecurlyBackupPassphraseLabel = UILabel.Style("⚠️ I understand that I'm responsible for securely backing up the keystore and might suffer permanent loss of all assets if I fail to do so.", numberOfLines: 0).make()

    private lazy var understandsRisksSwitch = UISwitch()
    private lazy var understandsRisksShortLabel: UILabel = "Keystore is backed up"
    private lazy var riskStackView = UIStackView.Style([understandsRisksSwitch, understandsRisksShortLabel], axis: .horizontal, margin: 0).make()
    private lazy var doneButton = UIButton.Style("I've backed up, proceed", isEnabled: false).make()


    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        beSafeLabel,
        keystoreTextView,
        copyKeystoreButton,
        urgeUserToSecurlyBackupPassphraseLabel,
        riskStackView,
        doneButton,
        .spacer
    ]

    override func setup() {
        understandsRisksSwitch.translatesAutoresizingMaskIntoConstraints = false
        keystoreTextView.addBorder()
    }
}

extension BackupWalletView: ViewModelled {
    typealias ViewModel = BackupWalletViewModel
    var userInput: UserInput {
        return UserInput(
            copyKeystoreToPasteboardTrigger: copyKeystoreButton.rx.tap.asDriver(),
            understandsRisk: understandsRisksSwitch.rx.isOn.asDriver(),
            doneTrigger: doneButton.rx.tap.asDriver()
        )
    }

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.keystoreText --> keystoreTextView,
            viewModel.isDoneButtonEnabled --> doneButton.rx.isEnabled
        ]
    }
}
