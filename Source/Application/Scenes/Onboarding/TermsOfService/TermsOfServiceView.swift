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

    private lazy var htmlView = WKWebView(file: "TermsOfService")
    private lazy var acceptTermsButton = UIButton.Style("Accept", isEnabled: false).make()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        htmlView,
        acceptTermsButton
    ]
}

extension TermsOfServiceView: ViewModelled {
    typealias ViewModel = TermsOfServiceViewModel
    var userInput: UserInput {

        let nearBottom = htmlView.scrollView.rx.didScroll.map { [unowned self] in
            return self.htmlView.scrollView.isContentOffsetNearBottom()
        }

        let didScrollToBottom = nearBottom.filter { $0 == true }.mapToVoid().asDriverOnErrorReturnEmpty()

        return UserInput(
            didScrollToBottom: didScrollToBottom,
            didAcceptTerms: acceptTermsButton.rx.tap.asDriverOnErrorReturnEmpty()
        )
    }

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.isAcceptButtonEnabled --> acceptTermsButton.rx.isEnabled
        ]
    }
}
