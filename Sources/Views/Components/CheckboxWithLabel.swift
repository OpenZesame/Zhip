//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
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

import Combine
import TinyConstraints
import UIKit

// MARK: - CheckboxView (native replacement for BEMCheckBox)

/// A lightweight native checkbox control that replaces the abandoned BEMCheckBox library.
final class CheckboxView: UIControl {
    // MARK: Public API (matches the BEMCheckBox API that was used in this project)

    var on: Bool = false {
        didSet {
            guard oldValue != on else { return }
            updateAppearance(animated: false)
        }
    }

    var onCheckColor: UIColor = .white
    var onFillColor: UIColor = .systemBlue
    var onTintColor: UIColor = .systemBlue
    var lineWidth: CGFloat = 1.5
    var cornerRadius: CGFloat = 3
    var animationDuration: TimeInterval = 0.2

    func setOn(_ on: Bool, animated: Bool) {
        guard self.on != on else { return }
        self.on = on
        updateAppearance(animated: animated)
    }

    // MARK: Private

    private let boxLayer = CAShapeLayer()
    private let checkLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        updateAppearance(animated: false)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
        updateAppearance(animated: false)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayerFrames()
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        setOn(!on, animated: true)
        sendActions(for: .valueChanged)
        return true
    }
}

// MARK: - Private drawing

private extension CheckboxView {
    func setupLayers() {
        boxLayer.fillColor = UIColor.clear.cgColor
        boxLayer.lineWidth = lineWidth
        layer.addSublayer(boxLayer)

        checkLayer.fillColor = UIColor.clear.cgColor
        checkLayer.lineWidth = lineWidth
        checkLayer.lineCap = .round
        checkLayer.lineJoin = .round
        layer.addSublayer(checkLayer)
    }

    func updateLayerFrames() {
        let rect = bounds
        boxLayer.frame = rect
        checkLayer.frame = rect

        let path = UIBezierPath(
            roundedRect: rect.insetBy(dx: lineWidth / 2, dy: lineWidth / 2),
            cornerRadius: cornerRadius
        )
        boxLayer.path = path.cgPath
        checkLayer.path = checkmarkPath(in: rect).cgPath
    }

    func checkmarkPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let w = rect.width
        let h = rect.height
        path.move(to: CGPoint(x: w * 0.2, y: h * 0.5))
        path.addLine(to: CGPoint(x: w * 0.42, y: h * 0.72))
        path.addLine(to: CGPoint(x: w * 0.8, y: h * 0.28))
        return path
    }

    func updateAppearance(animated: Bool) {
        let strokeColor = on ? onFillColor.cgColor : tintColor.cgColor
        let fillColor = on ? onFillColor.cgColor : UIColor.clear.cgColor
        let checkStroke = on ? onCheckColor.cgColor : UIColor.clear.cgColor

        let apply = {
            self.boxLayer.strokeColor = strokeColor
            self.boxLayer.fillColor = fillColor
            self.checkLayer.strokeColor = checkStroke
        }

        if animated, animationDuration > 0 {
            UIView.animate(withDuration: animationDuration) { apply() }
        } else {
            apply()
        }
    }
}

// MARK: - CheckboxWithLabel

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

    fileprivate lazy var checkbox: CheckboxView = {
        let size = CheckboxWithLabel.checkboxSize
        return CheckboxView(frame: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
    }()

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
                $0.alignment(alignment)
            } else {
                $0.alignment(style.numberOfLines == 0 ? .top : .fill)
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
        .init(numberOfLines: 0)
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
        checkbox.cornerRadius = 3
        checkbox.lineWidth = 1
        checkbox.onCheckColor = .teal
        checkbox.onFillColor = .deepBlue
        checkbox.onTintColor = .teal
        checkbox.tintColor = .teal
        checkbox.animationDuration = 0.2
    }
}

// MARK: - CheckboxWithLabel + Publishers

extension CheckboxWithLabel {
    var isCheckedPublisher: AnyPublisher<Bool, Never> {
        checkbox.isCheckedPublisher
    }
}

// MARK: - CheckboxView + Publishers

extension CheckboxView {
    var isCheckedPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            Just(on),
            publisher(for: .valueChanged).map { [weak self] _ in self?.on ?? false }
        )
        .eraseToAnyPublisher()
    }
}
