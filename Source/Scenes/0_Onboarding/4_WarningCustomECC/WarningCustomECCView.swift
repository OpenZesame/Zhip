//
//  WarningCustomECCView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-02-08.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class WarningCustomECCView: ScrollableStackViewOwner {

    private lazy var imageView          = UIImageView()
    private lazy var headerLabel        = UILabel()
    private lazy var textView           = UITextView()
    private lazy var acceptTermsButton  = UIButton()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        imageView,
        headerLabel,
        textView,
        acceptTermsButton
    ]

    override func setup() {
        setupSubviews()
    }
}

extension WarningCustomECCView: ViewModelled {
    typealias ViewModel = WarningCustomECCViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.isAcceptButtonEnabled --> acceptTermsButton.rx.isEnabled
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            didScrollToBottom: textView.rx.didScrollNearBottom(),
            didAcceptTerms: acceptTermsButton.rx.tap.asDriverOnErrorReturnEmpty()
        )
    }
}

private typealias € = L10n.Scene.WarningCustomECC
private typealias Image = Asset.Icons.Large
private extension WarningCustomECCView {
    func setupSubviews() {

        imageView.withStyle(.default) {
            $0.image(Image.warning.image)
        }

        headerLabel.withStyle(.header) {
            $0.text(€.Label.header)
        }

        acceptTermsButton.withStyle(.primary) {
            $0.title(€.Button.accept)
                .disabled()
        }

        textView.withStyle(.nonSelectable)
        textView.backgroundColor = .clear
        textView.attributedText = htmlAsAttributedString(htmlFileName: "CustomECCWarning")
    }
}
