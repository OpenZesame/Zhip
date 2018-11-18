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

    fileprivate let titleLabel: UILabel
    fileprivate let valueTextView: UITextView

    init(
        titleStyle: UILabel.Style? = nil,
        valueStyle: UITextView.Style? = nil,
        stackViewStyle: UIStackView.Style? = nil
        ) {

        let defaultTitleStyle = UILabel.Style(font: UIFont.Label.title, textColor: .black)

        let defaultValueStyle = UITextView.Style(
            font: UIFont.Label.value,
            textColor: .darkGray,
            isEditable: false,
            isScrollEnabled: false,
            // UILabel and UITextView horizontal alignment differs, change inset: stackoverflow.com/a/45113744/1311272
            contentInset: UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5)
        )

        let defaultStackViewStyle = UIStackView.Style(spacing: 8, margin: 0, isLayoutMarginsRelativeArrangement: false)

        self.titleLabel = defaultTitleStyle.merge(yieldingTo: titleStyle).make()
        self.valueTextView = defaultValueStyle.merge(yieldingTo: valueStyle).make()
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        apply(style: defaultStackViewStyle.merge(yieldingTo: stackViewStyle))
        [valueTextView, titleLabel].forEach { insertArrangedSubview($0, at: 0) }
    }

    required init(coder: NSCoder) { interfaceBuilderSucks }
}

extension TitledValueView {
    convenience init(
        title: String,
        valueStyle: UITextView.Style? = nil,
        stackViewStyle: UIStackView.Style? = nil
        ) {
        self.init(
            titleStyle: UILabel.Style(title),
            valueStyle: valueStyle,
            stackViewStyle: stackViewStyle
        )
    }
}

extension TitledValueView {
    func setValue(_ value: CustomStringConvertible) {
        valueTextView.text = value.description
    }

    func titled(_ text: CustomStringConvertible) -> TitledValueView {
        titleLabel.text = text.description
        return self
    }
}

extension Reactive where Base: TitledValueView {
    var title: Binder<String?> { return base.titleLabel.rx.text }
    var value: ControlProperty<String?> { return base.valueTextView.rx.text }
}
