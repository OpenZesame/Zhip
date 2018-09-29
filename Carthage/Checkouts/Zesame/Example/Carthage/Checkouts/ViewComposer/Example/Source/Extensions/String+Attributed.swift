//
//  String+Attributed.swift
//  Example
//
//  Created by Oscar Silver on 2017-09-03.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import Foundation

extension String {
    func applyAttributes(_ attributes: [NSAttributedString.Key: AnyObject], toSubstring substring: String) -> NSMutableAttributedString {
        let wholeStringAttributed = NSMutableAttributedString(string: self)
        return wholeStringAttributed.applyAttributes(attributes, toSubstring: substring)
    }
}

extension NSMutableAttributedString {
    func applyAttributes(_ attributes: [NSAttributedString.Key: Any], toSubstring substring: String) -> NSMutableAttributedString {
        let range = (string as NSString).range(of: substring)
        self.beginEditing()
        self.addAttributes(attributes, range: range)
        self.endEditing()
        return self
    }
}
