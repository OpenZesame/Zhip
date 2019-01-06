//
//  CheckboxWithLabel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-04.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import TinyConstraints
import M13Checkbox
import RxSwift
import RxCocoa

final class CheckboxWithLabel: UIControl {
    struct Style {
        var labelText: String?
        var numberOfLines: Int?
        init(
            labelText: String? = nil,
            numberOfLines: Int? = nil
            ) {
            self.labelText = labelText
            self.numberOfLines = numberOfLines
        }
    }

    static let checkboxSize: CGFloat = 24

    fileprivate lazy var checkbox = M13Checkbox(frame: .zero)
    private lazy var label = UILabel()

    private lazy var stackView = UIStackView(arrangedSubviews: [checkbox, label])

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        checkbox.toggleCheckState(true)
        return true
    }
}

extension CheckboxWithLabel {

    func apply(style: Style) {
        defer { setup() }
        label.withStyle(.checkbox) {
            $0.text(style.labelText)
                .numberOfLines(style.numberOfLines ?? 0)
        }

        stackView.withStyle(.horizontal) {
            // only by using `.top` alignment together with a label having `numberOfLines` set to 0
            // can we make the label span the height of the stackview. Altough we would like to add
            // the constraint: `label.centerY(to: checkbox)`, which indeed layouts these views
            // vertically aligned to their respective centers, it truncates the text of the label.
            $0.alignment(style.numberOfLines == 0 ? .top : .fill)
        }
    }

    @discardableResult
    func withStyle(_ style: Style, customize: ((Style) -> Style)? = nil) -> CheckboxWithLabel {
        translatesAutoresizingMaskIntoConstraints = false
        let style = customize?(style) ?? style
        apply(style: style)
        return self
    }
}

// MARK: - Style + Customizing
extension CheckboxWithLabel.Style {

    @discardableResult
    func text(_ text: String?) -> CheckboxWithLabel.Style {
        var style = self
        style.labelText = text
        return style
    }

    @discardableResult
    func numberOfLines(_ numberOfLines: Int) -> CheckboxWithLabel.Style {
        var style = self
        style.numberOfLines = numberOfLines
        return style
    }
}

// MARK: - Style Presets
extension CheckboxWithLabel.Style {
    static var `default`: CheckboxWithLabel.Style {
        return CheckboxWithLabel.Style(
            numberOfLines: 0
        )
    }
}

// MARK: - Private Setup
private extension CheckboxWithLabel {
    func setup() {
        addSubview(stackView)
        setupViews()
        setupConstraints()

        stackView.isUserInteractionEnabled = false
        label.isUserInteractionEnabled = false
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
        checkbox.cornerRadius = 3
        checkbox.boxLineWidth = 1
        checkbox.checkmarkLineWidth = 2

        // Color of box line in unchecked state
        checkbox.secondaryTintColor = .teal
        // Color of checkmark and box when checked
        checkbox.tintColor = .teal

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
