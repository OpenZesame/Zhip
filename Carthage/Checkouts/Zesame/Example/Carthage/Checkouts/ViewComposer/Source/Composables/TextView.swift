//
//  TextView.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-31.
//
//

import UIKit

open class TextView: UITextView, Composable {
    
    public let style: ViewStyle
    
    required public init(_ style: ViewStyle? = nil) {
        let style = style.merge(slave: .default)
        self.style = style
        super.init(frame: .zero, textContainer: nil)
        compose(with: style)
    }
    
    required public init?(coder: NSCoder) { requiredInit() }
}

private extension ViewStyle {
    @nonobjc static let `default`: ViewStyle = []
}

