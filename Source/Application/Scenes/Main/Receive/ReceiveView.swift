//
//  ReceiveView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Zesame

// MARK: - ReceiveView
private let stackViewMargin: CGFloat = 16
final class ReceiveView: ScrollingStackView {

    private lazy var walletView = WalletView()

    private lazy var copyMyAddressButton: UIButton = "Copy my address"
    private lazy var amountToReceiveField: UITextField = "Amount"
    private lazy var qrImageView = UIImageView()

    // MARK: - StackViewStyling
    lazy var stackViewStyle = UIStackView.Style([
        walletView,
        copyMyAddressButton,
        amountToReceiveField,
        qrImageView,
        .spacer
    ], margin: stackViewMargin)

    override func setup() {
        qrImageView.translatesAutoresizingMaskIntoConstraints = false
        qrImageView.contentMode = .scaleAspectFit
        qrImageView.clipsToBounds = true
    }
}

// MARK: - SingleContentView
extension ReceiveView: ViewModelled {
    typealias ViewModel = ReceiveViewModel

    var inputFromView: InputFromView {
        return InputFromView(
            copyMyAddressTrigger: copyMyAddressButton.rx.tap.asDriver(),
            qrCodeImageWidth: UIScreen.main.bounds.width - 2 * stackViewMargin,
            amountToReceive: amountToReceiveField.rx.text.orEmpty.asDriver()
        )
    }

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {

        return [
            viewModel.receivingAddress      --> walletView.rx.address,
            viewModel.qrImage               --> qrImageView.rx.image
        ]
    }
}
