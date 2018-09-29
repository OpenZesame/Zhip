//
//  MakeableUIWebViewViewController.swift
//  Example
//
//  Created by Alexander Cyon on 2017-06-13.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import UIKit

final class MakeableUIWebViewViewController: UIViewController {
    
    lazy var webView: UIWebView = [.color(.red)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadWebview()
    }
}

extension MakeableUIWebViewViewController: SingleSubviewOwner { var subview: UIWebView { return webView } }

private extension MakeableUIWebViewViewController {
    func loadWebview() {
        webView.loadRequest(.github)
    }
}

extension URLRequest {
    @nonobjc static let github = URLRequest(url: URL(string: "https://github.com/Sajjon/ViewComposer")!)
}
