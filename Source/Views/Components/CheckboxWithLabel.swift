//
//  CheckboxWithLabel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-04.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import TinyConstraints
import M13Checkbox
import RxSwift
import RxCocoa

final class CheckboxWithLabel: UIView {

    static let checkboxSize: CGFloat = 44

    fileprivate lazy var checkbox = M13Checkbox(frame: .zero)
    private let label: UILabel

    private lazy var stackView = UIStackView(arrangedSubviews: [checkbox, label]).withStyle(.horizontal) { customizableStyle in
        // only by using `.top` alignment together with a label having `numberOfLines` set to 0
        // can we make the label span the height of the stackview.
        customizableStyle.alignment(self.label.numberOfLines == 0 ? .top : .fill)
    }

    // MARK: Initialization
    init(titled: CustomStringConvertible? = nil, numberOfLines: Int = 0) {
        label = UILabel(text: titled).withStyle(.checkbox) { customizableStyle in
            customizableStyle.numberOfLines(numberOfLines)
        }
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }
}

// MARK: - Private Setup
private extension CheckboxWithLabel {
    func setup() {
        addSubview(stackView)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        setupCheckbox()
    }

    func setupConstraints() {
        stackView.edgesToSuperview()

        checkbox.height(CheckboxWithLabel.checkboxSize)
        checkbox.width(CheckboxWithLabel.checkboxSize)
    }

    func setupCheckbox() {
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.boxType = .square
        checkbox.cornerRadius = 5
        checkbox.boxLineWidth = 3
        checkbox.checkmarkLineWidth = 3

        // Color of box line in disabled state
        checkbox.secondaryTintColor = .gray
        // Color of checkmark and box when checked
        checkbox.tintColor = .green

    }
}

// MARK: - CheckboxWithLabel + Reactive
extension Reactive where Base: CheckboxWithLabel {
    var isChecked: ControlProperty<Bool> {
        return base.checkbox.rx.isChecked
    }
}

// MARK: - M13Checkbox + Reactive
extension Reactive where Base: M13Checkbox {
    var isChecked: ControlProperty<Bool> {
        return base.rx.controlProperty(editingEvents: .valueChanged, getter: {
            $0.checkState == .checked
        }, setter: {
            $0.setCheckState($1 ? .checked : .unchecked, animated: true)
        })
    }

    /// Reactive wrapper for `checkState` property.
    var state: ControlProperty<M13Checkbox.CheckState> {
        return base.rx.controlProperty(editingEvents: .valueChanged, getter: {
            return $0.checkState
        }, setter: {
            $0.setCheckState($1, animated: true)
        })
    }
}
