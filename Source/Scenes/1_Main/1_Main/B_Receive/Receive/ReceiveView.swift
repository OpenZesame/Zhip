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

    private lazy var qrImageView            = UIImageView()
    private lazy var addressView            = TitledValueView()
    private lazy var amountToReceiveField   = TextField()
    private lazy var shareButton            = UIButton()
    private lazy var copyMyAddressButton    = UIButton()
    private lazy var buttonsStackView       = UIStackView(arrangedSubviews: [shareButton, copyMyAddressButton])

    // MARK: - StackViewStyling
    lazy var stackViewStyle = UIStackView.Style([
        qrImageView,
        addressView,
        amountToReceiveField,
        buttonsStackView
        ], distribution: .equalSpacing)

    override func setup() {
        setupSubviews()
    }
}

// MARK: - SingleContentView
extension ReceiveView: ViewModelled {
    typealias ViewModel = ReceiveViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.receivingAddress      --> addressView.rx.value,
            viewModel.qrImage               --> qrImageView.rx.image
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            copyMyAddressTrigger: copyMyAddressButton.rx.tap.asDriver(),
            shareTrigger: shareButton.rx.tap.asDriverOnErrorReturnEmpty(),
            qrCodeImageWidth: UIScreen.main.bounds.width - stackView.layoutMargins.right - stackView.layoutMargins.left,
            amountToReceive: amountToReceiveField.rx.text.orEmpty.asDriver()
        )
    }
}

private typealias € = L10n.Scene.Receive
private extension ReceiveView {
    func setupSubviews() {
        qrImageView.withStyle(.default)

        addressView.titled(€.Label.myPublicAddress)

        amountToReceiveField.withStyle(.number) {
            $0.placeholder(€.Field.amount)
        }

        shareButton.withStyle(.secondary) {
            $0.title(€.Button.share)
        }

        copyMyAddressButton.withStyle(.primary) {
            $0.title(€.Button.copyMyAddress)
        }

        buttonsStackView.withStyle(.horizontalFillingEqually)
    }
}
