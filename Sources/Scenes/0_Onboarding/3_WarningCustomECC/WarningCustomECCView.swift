//
//  WarningCustomECCView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-02-08.
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
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
            viewModel.isAcceptButtonVisible --> acceptTermsButton.rx.isVisible,
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

private extension WarningCustomECCView {
    func setupSubviews() {

        imageView.withStyle(.default) {
            $0.image(UIImage(resource: .warningLarge))
        }

        headerLabel.withStyle(.header) {
            $0.text(String(localized: .WarningCustomECC.header))
        }

        acceptTermsButton.withStyle(.primary) {
            $0.title(String(localized: .WarningCustomECC.accept))
                .disabled()
        }

        textView.withStyle(.nonSelectable)
        textView.backgroundColor = .clear
        textView.attributedText = htmlAsAttributedString(htmlFileName: "CustomECCWarning")

        // Makes hyperlinks in HTML (href) clickable
        textView.isSelectable = true
    }
}
