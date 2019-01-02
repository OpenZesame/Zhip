//
//  WKWebView_Extensions.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import WebKit

extension WKWebView {

    convenience init(configuration: WKWebViewConfiguration = WKWebViewConfiguration()) {
        self.init(frame: .zero, configuration: configuration)
        translatesAutoresizingMaskIntoConstraints = false
    }

    func loadHtml(file: String, in bundle: Bundle = Bundle.main) {
        let htmlFile = Bundle.main.path(forResource: file, ofType: "html")!
        guard let html = try? String(contentsOfFile: htmlFile, encoding: .utf8) else {
            incorrectImplementation("Bad HTML file, fix it please.")
        }
        loadHTMLString(html, baseURL: nil)
    }
}
