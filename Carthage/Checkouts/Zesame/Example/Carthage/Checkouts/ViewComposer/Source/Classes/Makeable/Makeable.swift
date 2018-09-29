//
//  Makeable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-06.
//
//

import Foundation

/// Type that can be instantiated using static method `make([StyleType.Attribute])`
public protocol Makeable: EmptyInitializable, Styleable {
    /// Method for creating empty instance of a styleable type, e.g. a `UILabel`.
    ///
    /// Ultimately this static method would not be needed, but rather we would
    /// be able to create an instance using an empty initializer `init()`. Please
    /// refer to the discussion in the definition of `EmptyInitializable` protocol
    /// for why we cannot do that.
    /// - Parameter attributes: list of attributes used to make instance of `Styled`
    /// - Returns: Return `Styled` which is the type _itself_ conforming to the `Makeable` protocol.
    static func make(_ attributes: [StyleType.Attribute]) -> Styled
    
    /// Method run after `make`, use this for performing necessary setup after instance is created. E.g. the UIStackView adds its `arrangedSubviews` in this method.
    /// This method is "optional", by having an empty implementation in an extension to the `Makeable` protocol.
    ///
    /// - Parameter style: Result of the `Attribute`s array passed to static method `make`, containing the attributes styling this `Makeable`.
    func postMake(_ style: StyleType)
}

extension Makeable {
    
    /* Making method "optional" */
    public func postMake(_ style: StyleType) {}
    
    /// Allow for use of array literals statically like this `UIButton.make(.text("foo"), .textColor(.red))`
    public static func make(_ elements: StyleType.Attribute...) -> Styled {
        return make(elements)
    }
    
    /// Allows for use of static instatiation like this: `UIButton.make([.text("foo"), .textColor(.red)])`
    public static func make(_ attributes: [StyleType.Attribute]) -> Styled {
        let style: StyleType = attributes.merge(slave: []) // do not allow duplicates
        return make(style)
    }
    
    /// Statically creates a `Makeable` using a style - a collection of attributes.
    ///
    /// - Parameter style: `StyleType` contains a collection of attributes.
    /// - Returns: retuens a `Styled` instance, which refers to the `Makable` _itself_.
    public static func make(_ style: StyleType) -> Styled {
        let styled: Styled = createEmpty()
        if let selfStylable = styled as? Self {
            selfStylable.setup(with: style)
            selfStylable.postMake(style)
        }
        return styled
    }
}

/// Makes (pun intended) it possible to write `let label: UILabel = make([.text("hi")])` notice the lack of `.` in `.make`.
public func make<M: Makeable>(_ attributes: [M.StyleType.Attribute]) -> M where M.Styled == M {
    return M.make(attributes)
}

/// Makes (pun intended) it possible to write `let label: UILabel = make([.text("hi")])` notice the lack of `.` in `.make`.
public func make<M: Makeable>(_ style: M.StyleType) -> M where M.Styled == M {
    return M.make(style)
}

// Array literals support
public func make<M: Makeable>(_ attributes: M.StyleType.Attribute...) -> M where M.Styled == M {
    return make(attributes)
}
