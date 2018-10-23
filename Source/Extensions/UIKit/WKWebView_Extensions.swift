//
//  WKWebView_Extensions.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import WebKit

extension WKWebView {

    convenience init(file: String, in bundle: Bundle = Bundle.main) {
        self.init(frame: .zero, configuration: WKWebViewConfiguration())
        translatesAutoresizingMaskIntoConstraints = false
        let htmlFile = Bundle.main.path(forResource: file, ofType: "html")!
        let html = try! String(contentsOfFile: htmlFile, encoding: String.Encoding.utf8)
        loadHTMLString(html, baseURL: nil)
    }
}
