//
//  Button.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-31.
//
//

import UIKit

open class Button: UIButton, Composable {
    
    open var style: ViewStyle
    
    required public init(_ style: ViewStyle? = nil) {
        let style = style.merge(slave: .default)
        self.style = style
        super.init(frame: .zero)
        compose(with: style)
    }
    
    required public init?(coder: NSCoder) { requiredInit() }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        layoutSubviews(with: style)
    }
    
    public func setupSubviews(with style: ViewStyle) {
        let targets: [Actor] = [
            target(#selector(useBorderColorNormal), event: .touchUpInside),
            target(#selector(useBorderColorHighlighted), event: .touchDown)
        ]
        self.style = style <<- .targets(targets)
        targets.forEach { addTarget(using: $0) }
    }
}

private extension Button {
    
    @objc func useBorderColorHighlighted() {
        guard let highlighted = style.state(with: .highlighted), let borderColor = highlighted.borderColor else { return }
        layer.borderColor = borderColor.cgColor
    }
    
    @objc func useBorderColorNormal() {
        guard let highlighted = style.state(with: .normal), let borderColor = highlighted.borderColor else { return }
        layer.borderColor = borderColor.cgColor
    }
}

private extension ViewStyle {
    func state(with state: UIControl.State) -> ControlStateStyle? {
        guard let states: [ControlStateStyle] = value(.states) else { return nil }
        return states.filter { $0.state == state }.first
    }
}

private extension ViewStyle {
    @nonobjc static let `default`: ViewStyle = [.roundedBy(.height), .clipsToBounds(true), .verticalHugging(.high), .verticalCompression(.high)]
}
