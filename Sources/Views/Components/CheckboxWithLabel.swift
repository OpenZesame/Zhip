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

import TinyConstraints
import RxSwift
import RxCocoa
import BEMCheckBox

final class CheckboxWithLabel: UIControl {
    struct Style {
        var labelText: String?
        var numberOfLines: Int?
        var alignment: UIStackView.Alignment?
        init(
            labelText: String? = nil,
            numberOfLines: Int? = nil,
            alignment: UIStackView.Alignment? = nil
            ) {
            self.labelText = labelText
            self.numberOfLines = numberOfLines
            self.alignment = alignment
        }
    }

    static let checkboxSize: CGFloat = 24

    fileprivate lazy var checkbox = BEMCheckBox(frame: .init(origin: .zero, size: .init(width: CheckboxWithLabel.checkboxSize, height: CheckboxWithLabel.checkboxSize)))
    private lazy var label = UILabel()

    private lazy var stackView = UIStackView(arrangedSubviews: [checkbox, label])

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        checkbox.setOn(!checkbox.on, animated: true)
        checkbox.sendActions(for: .valueChanged)
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
            
            if let alignment = style.alignment {
                return $0.alignment(alignment)
            } else {
                // only by using `.top` alignment together with a label having `numberOfLines` set to 0
                // can we make the label span the height of the stackview. Altough we would like to add
                // the constraint: `label.centerY(to: checkbox)`, which indeed layouts these views
                // vertically aligned to their respective centers, it truncates the text of the label.
                return $0.alignment(style.numberOfLines == 0 ? .top : .fill)
            }
        }
    }

    @discardableResult
    func withStyle(
        _ style: Style,
        customize: ((Style) -> Style)? = nil
    ) -> CheckboxWithLabel {
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
        .init(
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
        checkbox.lineWidth = 1
        checkbox.onCheckColor = .teal
        checkbox.onFillColor = .deepBlue
        checkbox.onTintColor = .teal
        checkbox.tintColor = .teal
        checkbox.hideBox  = false
        checkbox.animationDuration = 0.2
    }
}

// MARK: - CheckboxWithLabel + Reactive
extension Reactive where Base: CheckboxWithLabel {
    var isChecked: ControlProperty<Bool> {
        return base.checkbox.rx.isChecked
    }
}

// MARK: - M13Checkbox + Reactive
extension Reactive where Base: BEMCheckBox {
    var isChecked: ControlProperty<Bool> {
        return base.rx.controlProperty(editingEvents: .valueChanged, getter: {
            $0.on
        }, setter: {
            $0.setOn($1, animated: true)
        })
    }
}
