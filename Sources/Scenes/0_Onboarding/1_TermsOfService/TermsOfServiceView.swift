// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation
import RxSwift
import RxCocoa

import UIKit
import WebKit

final class TermsOfServiceView: ScrollableStackViewOwner {

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

extension TermsOfServiceView: ViewModelled {
    typealias ViewModel = TermsOfServiceViewModel

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

private typealias € = L10n.Scene.TermsOfService
private typealias Image = Asset.Icons.Large
private extension TermsOfServiceView {
    func setupSubviews() {
        imageView.withStyle(.default) {
            $0.image(Image.analytics.image)
        }

        headerLabel.withStyle(.header) {
            $0.text(€.Label.termsOfService)
        }

        acceptTermsButton.withStyle(.primary) {
            $0.title(€.Button.accept)
                .disabled()
        }

        textView.withStyle(.nonSelectable)
        textView.backgroundColor = .clear
        textView.attributedText = htmlAsAttributedString(htmlFileName: "TermsOfService")
    }
}
