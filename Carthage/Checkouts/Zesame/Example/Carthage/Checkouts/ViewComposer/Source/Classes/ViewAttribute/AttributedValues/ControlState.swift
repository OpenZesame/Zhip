//
//  ControlStateStyle.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-31.
//
//

import UIKit

public class ControlStateStyle {
    public var state: UIControl.State { fatalError("Override me") }
    
    public var title: String?
    public var titleColor: UIColor?
    public var image: UIImage?
    public var borderColor: UIColor?
    public var backgroundColor: UIColor?
    
    public init(
        _ title: String? = nil,
        image: UIImage? = nil,
        titleColor: UIColor? = nil,
        backgroundColor: UIColor? = nil,
        borderColor: UIColor? = nil
    ) {
        self.title = title
        self.titleColor = titleColor
        self.image = image
        self.borderColor = borderColor
        self.backgroundColor = backgroundColor
    }
}

extension ControlStateStyle {
    
    public convenience init(_ title: String, _ titleColor: UIColor) {
        self.init(title, titleColor: titleColor)
    }
    
    public convenience init(_ title: String, _ image: UIImage) {
        self.init(title, image: image)
    }
    
    public convenience init(_ title: String, _ image: UIImage, _ titleColor: UIColor) {
        self.init(title, image: image, titleColor: titleColor)
    }
    
    public convenience init(_ titleColor: UIColor) {
        self.init(titleColor: titleColor)
    }
}

public class Normal: ControlStateStyle {
    public override var state: UIControl.State { return .normal }
}

public class Highlighted: ControlStateStyle {
    public override var state: UIControl.State { return .highlighted }
}

public class Disabled: ControlStateStyle {
    public override var state: UIControl.State { return .disabled }
}

public class Selected: ControlStateStyle {
    public override var state: UIControl.State { return .selected }
}

public class Focused: ControlStateStyle {
    public override var state: UIControl.State { return .focused }
}

public class Application: ControlStateStyle {
    public override var state: UIControl.State { return .application }
}

public class Reserved: ControlStateStyle {
    public override var state: UIControl.State { return .reserved }
}

extension ControlStateStyle: MergeableAttribute {
    public func merge(overwrittenBy other: ControlStateStyle) -> Self {
        guard state == other.state else { fatalError("Not same UIControl.State") }
        let merged = self
        merged.title = other.title ?? self.title
        merged.titleColor = other.titleColor ?? self.titleColor
        merged.image = other.image ?? self.image
        merged.borderColor = other.borderColor ?? self.borderColor
        return merged
    }
}

extension UIControl.State: Hashable {
    public var hashValue: Int { return rawValue.hashValue }
}

extension ControlStateStyle: Equatable {
    public static func == (lhs: ControlStateStyle, rhs: ControlStateStyle) -> Bool { return lhs.state == rhs.state }
}

extension ControlStateStyle: Hashable {
    public var hashValue: Int { return state.hashValue }
}

extension Array where Element == ControlStateStyle {
    public func merge(overwrittenBy other: [ControlStateStyle]) -> [ControlStateStyle] {
        
        let concatenated: [ControlStateStyle] = self + other
        
        let allTypes: [UIControl.State] = concatenated.map { $0.state }
        let duplicateOfDuplicates = allTypes.filter { (type: UIControl.State) in allTypes.filter { $0 == type }.count > 1 }
        //swiftlint:disable:next syntactic_sugar
        let duplicateTypes = Array<UIControl.State>(Set<UIControl.State>(duplicateOfDuplicates))
        
        var merged = [ControlStateStyle]()
        
        for duplicateType in duplicateTypes {
            let duplicateStates = concatenated.filter { $0.state == duplicateType }
            var duplicateState = duplicateStates[0]
            duplicateStates.forEach { duplicateState = duplicateState.merge(overwrittenBy: $0) }
            merged.append(duplicateState)
        }
        
        var set = Set<ControlStateStyle>(merged)
        concatenated.forEach { set.insert($0) }
        return Array(set)
    }
}

public struct ControlStateMerger: MergeInterceptor {
    public static func interceptMerge<A>(master masterAttributed: A, slave: A) -> A where A : Attributed {
        guard
            let master = masterAttributed as? ViewStyle,
            let slave = slave as? ViewStyle,
            let masterControlStates: [ControlStateStyle] = master.value(.states),
            let slaveControlStates: [ControlStateStyle] = slave.value(.states)
            else { return masterAttributed }
        let merged = slaveControlStates.merge(overwrittenBy: masterControlStates)
        //swiftlint:disable:next force_cast
        return ViewStyle([.states(merged)]) as! A
    }
}

