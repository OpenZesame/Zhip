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
    fileprivate lazy var checkbox = M13Checkbox(frame: .zero)
    private let label: UILabel

    private lazy var stackView = UIStackView(arrangedSubviews: [checkbox, label]).withStyle(.horizontal)

    // MARK: Initialization
    init(titled: CustomStringConvertible? = nil, height: CGFloat = 44) {
        label = UILabel(text: titled).withStyle(.checkbox)
        super.init(frame: .zero)
        setup(height: height)
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }
}

// MARK: - Private Setup
private extension CheckboxWithLabel {
    func setup(height: CGFloat) {
        addSubview(stackView)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupConstraints(height: height)
    }

    func setupViews() {
        setupCheckbox()
    }

    func setupConstraints(height: CGFloat) {
        stackView.edgesToSuperview()
        self.height(height)
        checkbox.width(height)
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
