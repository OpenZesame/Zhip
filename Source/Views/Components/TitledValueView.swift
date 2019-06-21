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
import RxSwift
import RxCocoa

final class TitledValueView: UIStackView {
    private var isSetup = false
    fileprivate let titleLabel = UILabel()
    fileprivate let valueTextView = UITextView()

    override func layoutSubviews() {
        super.layoutSubviews()
        guard isSetup else { incorrectImplementation("you should call `withStyles` method after init")}
    }
}

extension TitledValueView {
    
    // swiftlint:disable:next function_body_length
    func withStyles(
        forTitle titleStyle: UILabel.Style? = nil,
        forValue valueStyle: UITextView.Style? = nil,
        forStackView stackViewStyle: UIStackView.Style? = nil,
        customizeTitleStyle: ((UILabel.Style) -> (UILabel.Style))? = nil
    ) {
        defer { isSetup = true }
        var titleStyleUsed = titleStyle ?? UILabel.Style(font: .callToAction)
        titleStyleUsed = customizeTitleStyle?(titleStyleUsed) ?? titleStyleUsed

        let valueStyleUsed = valueStyle ?? UITextView.Style(
            font: UIFont.Label.body,
            isEditable: false,
            isScrollEnabled: false,
            // UILabel and UITextView horizontal alignment differs, change inset: stackoverflow.com/a/45113744/1311272
            contentInset: UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5)
        )

        titleLabel.withStyle(titleStyleUsed)
        valueTextView.withStyle(valueStyleUsed)
        translatesAutoresizingMaskIntoConstraints = false

        let defaultStackViewStyle = UIStackView.Style(
            spacing: 8,
            layoutMargins: .zero,
            isLayoutMarginsRelativeArrangement: false
        )
        
        let stackViewStyleUsed = stackViewStyle ?? defaultStackViewStyle

        apply(style: stackViewStyleUsed)
        [valueTextView, titleLabel].forEach { insertArrangedSubview($0, at: 0) }
    }

    func setValue(_ value: CustomStringConvertible) {
        valueTextView.text = value.description
    }

    @discardableResult
    func titled(_ text: CustomStringConvertible) -> TitledValueView {
        titleLabel.text = text.description
        return self
    }
}

extension Reactive where Base: TitledValueView {
    var title: Binder<String?> { return base.titleLabel.rx.text }
    var value: ControlProperty<String?> { return base.valueTextView.rx.text }
}
