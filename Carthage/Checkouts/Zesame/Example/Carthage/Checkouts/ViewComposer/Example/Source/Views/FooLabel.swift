//
//  FooLabel.swift
//  Example
//
//  Created by Alexander Cyon on 2017-06-03.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import UIKit
import ViewComposer

extension UIFont { @nonobjc static let big: UIFont = .boldSystemFont(ofSize: 25) }

final class FooLabel: UIView, FooProtocol {
    typealias StyleType = ViewStyle
    var foo: String? { didSet { label.text = foo } }
    let label: UILabel
    
    init(_ style: ViewStyle? = nil) {
        let style = style.merge(slave: [.textAlignment(.center), .font(.systemFont(ofSize: 40))])
        label = style <- [.textColor(.red)] //default textColor
        super.init(frame: .zero)
        compose(with: style)
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

extension FooLabel: Composable {
    func setupSubviews(with style: ViewStyle) {
        addSubview(label)
        addConstraint(label.topAnchor.constraint(equalTo: topAnchor))
        addConstraint(label.bottomAnchor.constraint(equalTo: bottomAnchor))
        addConstraint(label.leadingAnchor.constraint(equalTo: leadingAnchor))
        addConstraint(label.trailingAnchor.constraint(equalTo: trailingAnchor))
    }
}

enum FooAttribute {
    case foo(String)
}

struct FooStyle: BaseAttributed {
    let attributes: [FooAttribute]

    init(_ attributes: [FooAttribute]) {
        self.attributes = attributes
    }
    
    init(arrayLiteral elements: FooAttribute...) {
        self.attributes = elements
    }
    
    func install(on styleable: Any) {
        guard var foobar = styleable as? FooProtocol else { return }
        attributes.forEach {
            switch $0 {
            case .foo(let foo):
                foobar.foo = foo
            }
        }
    }
}

protocol FooProtocol {
    var foo: String? { get set }
}
