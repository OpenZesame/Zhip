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
        guard let html = try? String(contentsOfFile: htmlFile, encoding: .utf8) else {
            incorrectImplementation("Bad HTML file, fix it please.")
        }
        loadHTMLString(html, baseURL: nil)
    }
}
