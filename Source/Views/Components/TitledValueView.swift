//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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

        apply(style: defaultStackViewStyle)
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
