// 
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit
import RxSwift

final class BackupWalletView: ScrollableStackViewOwner {

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

    private lazy var haveSecurelyBackedUpCheckbox   = CheckboxWithLabel()
    private lazy var doneButton                     = UIButton()
    private lazy var haveSecurelyBackedUpViews      = UIStackView(arrangedSubviews: [haveSecurelyBackedUpCheckbox, doneButton])

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        backUpLabel,
        urgeBackupLabel,
        privateKeyViews,
        keystoreViews,
        .spacer,
        haveSecurelyBackedUpViews
    ]

    override func setup() {
        setupSubviews()
    }
}

extension BackupWalletView: ViewModelled {
    typealias ViewModel = BackupWalletViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.isHaveSecurelyBackedUpViewsVisible --> haveSecurelyBackedUpViews.rx.isVisible,
            viewModel.isDoneButtonEnabled    --> doneButton.rx.isEnabled
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            copyKeystoreToPasteboardTrigger: copyKeystoreButton.rx.tap.asDriver(),
            revealKeystoreTrigger: revealKeystoreButton.rx.tap.asDriver(),
            revealPrivateKeyTrigger: revealPrivateKeyButton.rx.tap.asDriver(),
            isUnderstandsRiskCheckboxChecked: haveSecurelyBackedUpCheckbox.rx.isChecked.asDriver(),
            doneTrigger: doneButton.rx.tap.asDriver()
        )
    }
}

private extension BackupWalletView {
    // swiftlint:disable:next function_body_length
    func setupSubviews() {

        backUpLabel.withStyle(.header) {
            $0.text(String(localized: .BackupWallet.backUpKeys))
        }

        urgeBackupLabel.withStyle(.body) {
            $0.text(String(localized: .BackupWallet.urgeBackup))
        }

        privateKeyLabel.withStyle(.checkbox) {
            $0.text(String(localized: .BackupWallet.privateKeyLabel))
        }

        revealPrivateKeyButton.withStyle(.hollow) {
            $0.title(String(localized: .BackupWallet.reveal))
        }

        privateKeyButtonContainer.withStyle(.horizontal)

        privateKeyViews.withStyle(.vertical)

        keystoreLabel.withStyle(.checkbox) {
            $0.text(String(localized: .BackupWallet.keystoreLabel))
        }

        copyKeystoreButton.withStyle(.hollow) {
            $0.title(String(localized: .BackupWallet.copy))
        }

        revealKeystoreButton.withStyle(.hollow) {
            $0.title(String(localized: .BackupWallet.reveal))
        }

        keystoreButtons.withStyle(.horizontal)

        keystoreViews.withStyle(.vertical)

        haveSecurelyBackedUpViews.withStyle(.vertical)

        haveSecurelyBackedUpCheckbox.withStyle(.default) {
            $0.text(String(localized: .BackupWallet.haveSecurelyBackedUp))
        }

        [copyKeystoreButton, revealKeystoreButton, revealPrivateKeyButton].forEach {
            $0.width(136)
        }

        doneButton.withStyle(.primary) {
            $0.title(String(localized: .BackupWallet.done))
                .disabled()
        }
    }
}
