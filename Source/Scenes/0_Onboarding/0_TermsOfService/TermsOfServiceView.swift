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

private typealias € = L10n.Scene.TermsOfService

final class TermsOfServiceView: ScrollingStackView {

    private lazy var htmlView = WKWebView(file: "TermsOfService")
    
    private lazy var acceptTermsButton = UIButton(title: €.Button.accept)
        .withStyle(.primary)
        .disabled()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        htmlView,
        acceptTermsButton
    ]
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
