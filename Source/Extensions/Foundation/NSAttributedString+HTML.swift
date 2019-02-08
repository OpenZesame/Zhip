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

import UIKit

func htmlAsAttributedString(
    htmlFileName: String,
    textColor: UIColor = .white,
    font: UIFont = .body
    ) -> NSAttributedString {

    guard let path = Bundle.main.path(forResource: htmlFileName, ofType: "html") else {
        incorrectImplementation("bad path")
    }
    do {
        let htmlBodyString = try String(contentsOfFile: path, encoding: .utf8)

        return generateHTMLWithCSS(
            htmlBodyString: htmlBodyString,
            textColor: textColor,
            font: font
        )
    } catch {
        incorrectImplementation("Failed to read contents of file, error: \(error)")
    }
}

// swiftlint:disable:next function_body_length
func generateHTMLWithCSS(
    htmlBodyString: String,
    textColor: UIColor,
    font: UIFont
    ) -> NSAttributedString {

    guard let htmlData = NSString(string: htmlBodyString).data(using: String.Encoding.unicode.rawValue) else {
        incorrectImplementation("Failed to convert html to data")
    }

    do {
        let attributexText = try NSMutableAttributedString(
            data: htmlData,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        )
        attributexText.setFontFace(font: font, color: textColor)
        return attributexText
    } catch {
        incorrectImplementation("Failed to create attributed string")
    }
}

extension NSMutableAttributedString {
    func setFontFace(font: UIFont, color: UIColor? = nil) {
        beginEditing(); defer { endEditing() }

        let range = NSRange(location: 0, length: length)

        enumerateAttribute(.font, in: range) { (value, range, stop) in

            guard
                let f = value as? UIFont,
                let newFontDescriptor = f.fontDescriptor.withFamily(font.familyName).withSymbolicTraits(f.fontDescriptor.symbolicTraits)
                else { return }

            let newFont = UIFont(descriptor: newFontDescriptor, size: font.pointSize)

            removeAttribute(.font, range: range)
            addAttribute(.font, value: newFont, range: range)

            guard let color = color else { return }

            removeAttribute(.foregroundColor, range: range)
            addAttribute(.foregroundColor, value: color, range: range)
        }
    }
}
