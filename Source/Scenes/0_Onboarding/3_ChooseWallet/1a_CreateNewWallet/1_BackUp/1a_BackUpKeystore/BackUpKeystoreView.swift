//
//  BackUpKeystoreView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

private typealias € = L10n.Scene.BackUpKeystore

final class BackUpKeystoreView: ScrollingStackView {

    private lazy var keystoreTextView = UITextView().withStyle(.nonEditable)

    private lazy var copyButton = UIButton(title: €.Button.copy).withStyle(.primary)

    lazy var stackViewStyle: UIStackView.Style = [
        keystoreTextView,
        copyButton
    ]

    override func setup() {
        keystoreTextView.textAlignment = .left
    }
}

extension BackUpKeystoreView: ViewModelled {
    typealias ViewModel = BackUpKeystoreViewModel

    func populate(with viewModel: BackUpKeystoreViewModel.Output) -> [Disposable] {
        return [
            viewModel.keystore --> keystoreTextView.rx.text
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            copyTrigger: copyButton.rx.tap.asDriver()
        )
    }
}
