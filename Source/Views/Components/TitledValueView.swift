//
//  TitledValueView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-14.
//  Copyright © 2018 Open Zesame. All rights reserved.
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
        let defaultStackViewStyle = UIStackView.Style(spacing: 8, margin: 0, isLayoutMarginsRelativeArrangement: false)

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
