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
final class ReceiveView: ScrollingStackView {

    private lazy var walletView = WalletView()

    private lazy var amountToReceiveField = UITextField.Style("Amount", text: "0").make()
    private lazy var qrImageView = UIImageView()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        walletView,
        amountToReceiveField,
        qrImageView,
        .spacer
    ]

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
