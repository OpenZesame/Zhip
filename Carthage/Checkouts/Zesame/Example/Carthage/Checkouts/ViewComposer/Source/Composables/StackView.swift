//
//  StackView.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-31.
//
//

import Foundation

open class StackView: UIStackView {
    public let style: ViewStyle
    open var backgroundColorView: UIView?
    
    required public init(_ style: ViewStyle? = nil) {
        let style = style.merge(slave: .default)
        self.style = style
        super.init(frame: .zero)
        compose(with: style)
    }
    
    required public init(coder: NSCoder) { requiredInit() }
}

extension StackView: Composable {
    public func setupSubviews(with style: ViewStyle) {
        setupArrangedSubviews(with: style)
        setupBackgroundView(with: style)
    }
}

public extension StackView {
    func setupBackgroundView(with style: ViewStyle) {
        if let backgroundColor: UIColor = style.value(.color) {
            setupBackgroundView(with: backgroundColor)
        }
    }
    
    func setupBackgroundView(with color: UIColor) {
        let backgroundColorView = UIView()
        backgroundColorView.translatesAutoresizingMaskIntoConstraints = false
        backgroundColorView.backgroundColor = color
        addSubview(backgroundColorView)
        sendSubviewToBack(backgroundColorView)
        addConstraint(backgroundColorView.topAnchor.constraint(equalTo: self.topAnchor))
        addConstraint(backgroundColorView.leadingAnchor.constraint(equalTo: self.leadingAnchor))
        addConstraint(backgroundColorView.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        addConstraint(backgroundColorView.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        self.backgroundColorView = backgroundColorView
    }
}

private extension ViewStyle {
    @nonobjc static let `default`: ViewStyle = [.axis(.vertical)]
}
