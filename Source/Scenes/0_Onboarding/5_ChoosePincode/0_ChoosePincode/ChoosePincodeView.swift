//
//  ChoosePincodeView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

final class ChoosePincodeView: ScrollableStackViewOwner {

    private lazy var inputPincodeView           = InputPincodeView()
    private lazy var pinOnlyLocksAppTextView    = UITextView()
    private lazy var doneButton                 = UIButton()

    lazy var stackViewStyle: UIStackView.Style = [
        inputPincodeView,
        pinOnlyLocksAppTextView,
        doneButton
    ]

    override func setup() {
        setupSubviews()
    }
}

extension ChoosePincodeView: ViewModelled {
    typealias ViewModel = ChoosePincodeViewModel

    var inputFromView: InputFromView {
        return InputFromView(
            pincode: inputPincodeView.rx.pincode.asDriver(),
            doneTrigger: doneButton.rx.tap.asDriver()
        )
    }

    func populate(with viewModel: ChoosePincodeViewModel.Output) -> [Disposable] {
        return [
            viewModel.inputBecomeFirstResponder --> inputPincodeView.rx.becomeFirstResponder,
            viewModel.isDoneButtonEnabled       --> doneButton.rx.isEnabled
        ]
    }
}

private typealias € = L10n.Scene.ChoosePincode
private extension ChoosePincodeView {
    func setupSubviews() {
        pinOnlyLocksAppTextView.withStyle(.nonSelectable) {
            $0.text(€.Text.pincodeOnlyLocksApp).textColor(.silverGrey)
        }

        doneButton.withStyle(.primary) {
            $0.title(€.Button.done)
                .disabled()
        }
    }
}
