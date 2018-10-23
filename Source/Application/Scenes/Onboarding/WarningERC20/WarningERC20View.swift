//
//  WarningERC20View.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

final class WarningERC20View: ScrollingStackView {

    private lazy var warningTextView = UITextView.Style("""
        ⚠️⚠️⚠️ WARNING ⚠️⚠️⚠️
        This is a Zilliqa testnet. Please do not send any interim ERC-20 ZIL tokens to this wallet.

        Zilliqa and the Ethereum blockchain are two completely separate platforms and the mneumonic phrases, private keys, addresses and tokens CANNOT be shared.

        Transferring assets directly from Ethereum to Zilliqa (or vice versa) will cause irreparable loss.
    """, textAlignment: .center, isEditable: false).make()

    private lazy var acceptButton = UIButton.Style("I understand", textColor: .white, colorNormal: .black).make()
    private lazy var doNotShowThisAgainButton = UIButton.Style("Do not show this again", textColor: .gray, colorNormal: .clear).make()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        warningTextView,
        acceptButton,
        doNotShowThisAgainButton,
    ]
}

extension WarningERC20View: ViewModelled {
    typealias ViewModel = WarningERC20ViewModel
    var userInput: UserInput {

        return UserInput(
            accept: acceptButton.rx.tap.asDriverOnErrorReturnEmpty(),
            doNotShowAgain: doNotShowThisAgainButton.rx.tap.asDriverOnErrorReturnEmpty()
        )

    }
}
