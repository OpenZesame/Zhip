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

final class BackUpKeystoreView: ScrollingStackView {

    private lazy var keystoreTextView   = UITextView()
    private lazy var copyButton         = UIButton()

    lazy var stackViewStyle: UIStackView.Style = [
        keystoreTextView,
        copyButton
    ]

    override func setup() {
        setupSubviews()
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

private typealias € = L10n.Scene.BackUpKeystore
private extension BackUpKeystoreView {
    func setupSubviews() {
        keystoreTextView.withStyle(.nonEditable) {
            $0.textAlignment(.left)
        }

        copyButton.withStyle(.primary) {
            $0.title(€.Button.copy)
        }
    }
}
