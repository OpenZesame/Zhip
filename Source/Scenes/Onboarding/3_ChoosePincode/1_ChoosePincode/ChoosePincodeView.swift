//
//  ChoosePincodeView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

private typealias € = L10n.Scene.ChoosePincode

final class ChoosePincodeView: ScrollingStackView {

    private lazy var inputPincodeView = InputPincodeView(.setNew)

    private lazy var confirmPincodeButton = UIButton.Style(€.Button.confirmPincode, isEnabled: false).make()

    lazy var stackViewStyle: UIStackView.Style = [
        inputPincodeView,
        confirmPincodeButton,
        .spacer
    ]
}

extension ChoosePincodeView: ViewModelled {
    typealias ViewModel = ChoosePincodeViewModel

    var inputFromView: InputFromView {
        return InputFromView(
            pincode: inputPincodeView.pincode,
            confirmedTrigger: confirmPincodeButton.rx.tap.asDriver()
        )
    }

    func populate(with viewModel: ChoosePincodeViewModel.Output) -> [Disposable] {
        return [
            viewModel.isConfirmPincodeEnabled --> confirmPincodeButton.rx.isEnabled
        ]
    }
}
