//
//  MakeableWKWebViewViewController.swift
//  Example
//
//  Created by Alexander Cyon on 2017-06-13.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import UIKit
import WebKit
import ViewComposer

private let webViewProgressKeyPath = #keyPath(WKWebView.estimatedProgress)

final class MakeableWKWebViewViewController: UIViewController, StackViewOwner {

    lazy var spinner: UIActivityIndicatorView = [.spinnerScale(3)]
    
    lazy var progressView: UIProgressView = [ViewAttribute.progress(0.1), .progressTintColor(.red), .height(3)]
    lazy var webView: WKWebView = [.webPage(.github), .delegate(self)]
    
    lazy var stackView: StackView = [.views([self.progressView, self.webView]), .verticalCompression(.low)]^
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        webView.addObserver(self, forKeyPath: webViewProgressKeyPath, options: .new, context: nil)
        view.addSubview(spinner); spinner.pinEdges(to: view)
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: webViewProgressKeyPath)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath, keyPath == webViewProgressKeyPath, let progress = change?[.newKey] as? Float else { return }
        progressView.progress = progress
    }
}

extension MakeableWKWebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
    }
}
