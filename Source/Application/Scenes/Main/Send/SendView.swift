//
//  SendView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Zesame

// MARK: - SendView
final class SendView: ScrollingStackView {

    private lazy var walletBalanceView = WalletBalanceView()

    private lazy var recipientAddressField = UITextField.Style("To address", text: "74C544A11795905C2C9808F9E78D8156159D32E4").make()
    private lazy var amountToSendField = UITextField.Style("Amount", text: "11").make()
    private lazy var gasLimitField = UITextField.Style("Gas limit", text: "1").make()
    private lazy var gasPriceField = UITextField.Style("Gas price", text: "1").make()
    private lazy var encryptionPassphraseField = UITextField.Style("Wallet Encryption Passphrase", text: "apabanan").make()
    private lazy var sendButton: UIButton = "Send"
    private lazy var transactionIdentifierLabel: UILabel = "No tx"

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        walletBalanceView,
        recipientAddressField,
        amountToSendField,
        gasLimitField,
        gasPriceField,
        encryptionPassphraseField,
        sendButton,
        transactionIdentifierLabel,
        .spacer
    ]
}

// MARK: - SingleContentView
extension SendView: ViewModelled {
    typealias ViewModel = SendViewModel

    var userInput: UserInput {
        return UserInput(
            sendTrigger: sendButton.rx.tap.asDriver(),
            recepientAddress: recipientAddressField.rx.text.orEmpty.asDriver(),
            amountToSend: amountToSendField.rx.text.orEmpty.asDriver(),
            gasLimit: gasLimitField.rx.text.orEmpty.asDriver(),
            gasPrice: gasPriceField.rx.text.orEmpty.asDriver(),
            encryptionPassphrase: encryptionPassphraseField.rx.text.orEmpty.asDriver()
        )
    }

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {

        return [
            viewModel.walletBalance             --> walletBalanceView.rx.wallet,
            viewModel.isRecipientAddressValid   --> encryptionPassphraseField.rx.isValid,
            viewModel.transactionId             --> transactionIdentifierLabel
        ]
    }
}

extension Reactive where Base: UITextField {
    var isValid: Binder<Bool> {
        return Binder<Bool>(base) {
            $0.mark(isValid: $1)
        }
    }
}

extension UITextField {
    func mark(isValid: Bool) {
        layer.borderWidth = isValid ? 0 : 2
        let borderColor: UIColor = isValid ? .clear : .red
        layer.borderColor = borderColor.cgColor
    }
}
