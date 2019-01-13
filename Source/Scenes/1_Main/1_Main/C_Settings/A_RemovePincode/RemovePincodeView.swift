//
//  RemovePincodeView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

private typealias € = L10n.Scene.RemovePincode

final class RemovePincodeView: ScrollableStackViewOwner {

    private lazy var inputPincodeView = InputPincodeView()

    lazy var stackViewStyle: UIStackView.Style = [
        inputPincodeView,
        .spacer
    ]

    override func setup() {
        inputPincodeView.becomeFirstResponder()
    }
}

extension RemovePincodeView: ViewModelled {
    typealias ViewModel = RemovePincodeViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.inputBecomeFirstResponder --> inputPincodeView.rx.becomeFirstResponder,
            viewModel.pincodeValidation         --> inputPincodeView.rx.validation
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            pincode: inputPincodeView.rx.pincode.asDriver()
        )
    }
}
