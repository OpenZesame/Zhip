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

final class DigitView: UIView {

    private lazy var label = UILabel()

    private lazy var underline: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.height(3)
        view.backgroundColor = AnyValidation.Color.validWithoutRemark
        return view
    }()

    lazy var stackView = UIStackView(arrangedSubviews: [label, underline])

    private let isSecureTextEntry: Bool

    init(isSecureTextEntry: Bool) {
        self.isSecureTextEntry = isSecureTextEntry
        super.init(frame: .zero)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }

    public func updateWithNumberOrBullet(text: String?) {
        guard let text = text else {
            label.text = nil
            return
        }
        let labelText = isSecureTextEntry ? "•" : text
        label.text = labelText
    }

    func colorUnderlineView(with color: UIColor) {
        underline.backgroundColor = color
    }

    private func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.edgesToSuperview()

        stackView.withStyle(.init(spacing: 4, layoutMargins: .zero))

        let font: UIFont = isSecureTextEntry ? .bigBang : .impression
        label.withStyle(.impression) {
            $0.textAlignment(.center)
                .font(font)
        }
    }
}
