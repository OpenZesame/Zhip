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

extension PincodeTextField {
    final class Presentation: UIStackView {

        private var digitViews: [DigitView] {
            let digitViews = arrangedSubviews.compactMap { $0 as? DigitView }
            assert(digitViews.count == length)
            return digitViews
        }

        let length: Int
        private let widthOfDigitView: CGFloat
        private let isSecureTextEntry: Bool

        init(length: Int, widthOfDigitView: CGFloat, isSecureTextEntry: Bool = true) {
            self.length = length
            self.widthOfDigitView = widthOfDigitView
            self.isSecureTextEntry = isSecureTextEntry
            super.init(frame: .zero)
            setup()
        }

        required init(coder: NSCoder) { interfaceBuilderSucks }

        func colorUnderlineViews(with color: UIColor) {
            digitViews.forEach {
                $0.colorUnderlineView(with: color)
            }
        }

        func setPincode(_ digits: [Digit]) {
            digitViews.forEach {
                $0.updateWithNumberOrBullet(text: nil)
            }
            for (index, digit) in digits.enumerated() {
                digitViews[index].updateWithNumberOrBullet(text: String(describing: digit))
            }
        }

        private func setup() {
            withStyle(.horizontalEqualCentering)
            [Void](repeating: (), count: length).map { DigitView(isSecureTextEntry: isSecureTextEntry) }.forEach {
                addArrangedSubview($0)
                $0.heightToSuperview()
                $0.width(widthOfDigitView)
            }

            isUserInteractionEnabled = false

            // add spacers left and right, centering the digit views
            insertArrangedSubview(.spacer, at: 0)
            addArrangedSubview(.spacer)
        }
    }
}
