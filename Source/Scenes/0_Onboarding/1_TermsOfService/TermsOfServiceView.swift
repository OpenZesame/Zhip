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

    private lazy var webView           = WKWebView(file: "TermsOfService")
    private lazy var acceptTermsButton  = UIButton()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        webView,
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
        let nearBottom = webView.scrollView.rx.didScroll.map { [unowned self] in
            return self.webView.scrollView.isContentOffsetNearBottom()
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

        webView.navigationDelegate = self
        webView.alpha = 0

        acceptTermsButton.withStyle(.primary) {
            $0.title(€.Button.accept)
                .disabled()
        }
    }
}

extension TermsOfServiceView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let css = "body { background-color: \(UIColor.deepBlue.hexString); color: \(UIColor.white.hexString); }"
        log.debug(css)

//        NSData* data = UIImageJPEGRepresentation(image, 1.0f);

//        NSString *strEncoded = [data base64Encoding];

        let image = Asset.analytics.image // should be Terms of Service image
        let imageAsJPEGData = image.jpegData(compressionQuality: 1)!
        let imageAsJPEGDataEncoded = imageAsJPEGData.base64EncodedString()

        let imageSectionHtml = """
            <img style="opacity: 1.0"; src='data:image/png;base64,\(imageAsJPEGDataEncoded)'/>
        """

        log.debug(imageSectionHtml)

        let js = """
            var style = document.createElement("style");
            style.innerHTML = "\(css)";
            document.head.appendChild(style);

            var imageDiv = document.createElement("div");
            imageDiv.innerHTML = "\(imageSectionHtml)";
            document.body.appendChild(imageDiv);
        """

        log.debug(js)

        webView.evaluateJavaScript(js) { foobar, error in
            if let error = error {
                log.error(error)
            }

        }
        webView.alpha = 1
    }
}
