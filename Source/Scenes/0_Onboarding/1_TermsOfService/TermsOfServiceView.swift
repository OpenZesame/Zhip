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
            viewModel.isAcceptButtonEnabled --> acceptTermsButton.rx.isEnabled
        ]
    }

    var inputFromView: InputFromView {
        let didScrollNearBottom = textView.rx.contentOffset.map { [unowned textView] in
            $0.y >= 0.95 * textView.contentSize.height
        }.filter { $0 }.mapToVoid().asDriverOnErrorReturnEmpty()

        return InputFromView(
            didScrollToBottom: didScrollNearBottom,
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
        textView.attributedText = htmlAsAttributedString()
    }

    private func htmlAsAttributedString(
        textColor: UIColor = .white,
        font: UIFont = .body
    ) -> NSAttributedString {

        guard let path = Bundle.main.path(forResource: "TermsOfService", ofType: "html") else {
            incorrectImplementation("bad path")
        }
        do {
            let htmlBodyString = try String(contentsOfFile: path, encoding: .utf8)

            return generateTermsOfServiceHTMLWithCSS(
                htmlBodyString: htmlBodyString,
                textColor: textColor,
                font: font
            )
        } catch {
            incorrectImplementation("Failed to read contents of file, error: \(error)")
        }
    }

    // swiftlint:disable:next function_body_length
    private func generateTermsOfServiceHTMLWithCSS(
        htmlBodyString: String,
        textColor: UIColor,
        font: UIFont
    ) -> NSAttributedString {

        let htmlString = """
            <html>
                <head>
                    <style>
                        body {
                            color: \(textColor.hexString);
                        }
                    </style>
                </head>
                <body>
                    \(htmlBodyString)
                </body>
            </html>
        """

        guard let htmlData = NSString(string: htmlString).data(using: String.Encoding.unicode.rawValue) else {
            incorrectImplementation("Failed to convert html to data")
        }

        do {
            let attributexText = try NSMutableAttributedString(
                data: htmlData,
                options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
            )
            let range = NSRange(location: 0, length: attributexText.string.count)
            attributexText.addAttribute(.font, value: font, range: range)
            return attributexText
        } catch {
            incorrectImplementation("Failed to create attributed string")
        }
    }
}
