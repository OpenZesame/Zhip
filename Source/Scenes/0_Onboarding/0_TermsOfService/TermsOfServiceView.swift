//
//  TermsOfServiceView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

import UIKit
import WebKit

final class TermsOfServiceView: ScrollingStackView {

    private lazy var htmlView           = WKWebView(file: "TermsOfService")
    private lazy var acceptTermsButton  = UIButton()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        htmlView,
        acceptTermsButton
    ]

    override func setup() {
        setupSubviews()
    }
}

extension TermsOfServiceView: ViewModelled {
    typealias ViewModel = TermsOfServiceViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.isAcceptButtonEnabled --> acceptTermsButton.rx.isEnabled
        ]
    }

    var inputFromView: InputFromView {

        let nearBottom = htmlView.scrollView.rx.didScroll.map { [unowned self] in
            return self.htmlView.scrollView.isContentOffsetNearBottom()
        }

        let didScrollToBottom = nearBottom.filter { $0 == true }.mapToVoid().asDriverOnErrorReturnEmpty()

        return InputFromView(
            didScrollToBottom: didScrollToBottom,
            didAcceptTerms: acceptTermsButton.rx.tap.asDriverOnErrorReturnEmpty()
        )
    }
}

private typealias € = L10n.Scene.TermsOfService
private extension TermsOfServiceView {
    func setupSubviews() {
        acceptTermsButton.withStyle(.primary) {
            $0.title(€.Button.accept)
                .disabled()
        }
    }
}
