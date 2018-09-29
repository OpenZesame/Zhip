//
//  Attributed.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-31.
//
//

import Foundation

public protocol AssociatedValueEnumExtractor {
    var associatedValue: Any? { get }
}

public protocol StrippedRepresentation: RawRepresentable, Hashable, Comparable {}
public protocol AssociatedValueStrippable: Comparable {
    associatedtype Stripped: StrippedRepresentation
    var stripped: Stripped { get }
}

public typealias AttributeType = AssociatedValueStrippable & AssociatedValueEnumExtractor

public protocol ExpressibleByAttributes: BaseAttributed {
    /// `Attribute` type used to style. Needs conformancs to `AssociatedValueStrippable` and `AssociatedValueEnumExtractor`
    /// so that we can perform merging operations and also logic such as `contains:attribute` and `value` extraction,
    /// accessing the value associated to a certain attribute. e.g. the `UIColor` associated to the attribute `backgroundColor`
    associatedtype Attribute: AttributeType
    
    init(attributes: [Attribute])
    
    /// Attributes used to style some `Styleable` type
    var attributes: [Attribute] { get }
}

public protocol AttributesMergable: ExpressibleByAttributes {

    //MARK: - Merging methods
    func merge(slave: Self, intercept: Bool) -> Self
}

public protocol AttributesDuplicationHandler: AttributesMergable {
    static var duplicatesHandler: AnyDuplicatesHandler<Self>? { get set }
}

public protocol AttributesMergableIntercepting: AttributesDuplicationHandler {
    static var mergeInterceptors: [MergeInterceptor.Type] { get set }
}

public protocol CustomStyling: AttributesMergableIntercepting {
    static var customStyler: AnyCustomStyler<Self>? { get set }
}

/// Type that holds a collection of attributes used to style some `Styleable`. 
/// This collection can be merged with another instance of it sharing the same `Attribute` associatedtype.
/// You can also extract values associated to a certain attribute e.g. the `UIColor` associated to the attribute `backgroundColor`.
public protocol Attributed: CustomStyling, Collection, ExpressibleByArrayLiteral, CustomStringConvertible {
    
    /// Needed for conformance to `Collection`
    var startIndex: Int { get }
    
    //MARK: - Collection associatedtypes
    associatedtype Index = Int
    associatedtype Iterator = IndexingIterator<Self>
    associatedtype Indices = DefaultIndices<Self>
}

extension Attributed {
    public init(_ attributes: [Attribute]) {
        self.init(attributes: Self.removeDuplicatesIfNeededAndAble(attributes))
    }
}

public protocol DuplicatesHandler {
    associatedtype AttributesExpressible: ExpressibleByAttributes
    func choseDuplicate(from duplicates: [AttributesExpressible.Attribute]) -> AttributesExpressible.Attribute
}

public struct AnyDuplicatesHandler<E: ExpressibleByAttributes>: DuplicatesHandler {
    public typealias AttributesExpressible = E
    public typealias Attribute = AttributesExpressible.Attribute
    
    var _chooseDuplicate: ([Attribute]) -> Attribute

    public init<D: DuplicatesHandler>(_ concrete: D) where D.AttributesExpressible == AttributesExpressible {
        _chooseDuplicate = { concrete.choseDuplicate(from: $0) }
    }
    
    public func choseDuplicate(from duplicates: [Attribute]) -> Attribute { return _chooseDuplicate(duplicates) }
}

public protocol CustomStyler {
    associatedtype AttributesExpressible: ExpressibleByAttributes
    func customStyle(_ styleable: Any, with style: AttributesExpressible)
}

public struct AnyCustomStyler<E: ExpressibleByAttributes>: CustomStyler {
    public typealias AttributesExpressible = E
    var _customStyle: (Any, AttributesExpressible) -> Void
    public init<Concrete: CustomStyler>(_ concrete: Concrete) where Concrete.AttributesExpressible == AttributesExpressible {
        _customStyle = { concrete.customStyle($0, with: $1) }
    }
    
    public func customStyle(_ styleable: Any, with style: E) {
        _customStyle(styleable, style)
    }
}

extension Attributed {
    
    /// Transforms `[A(1), A(2), A(7)` to `A(x)` where `x` is the selected 
    // associated value from the array of duplicate attributes according to 
    // the DuplicatesHandler if any, or the default one.
    static func choseDuplicate(from duplicates: [Attribute]) -> Attribute? {
        guard let duplicatesHandler = duplicatesHandler else { return duplicates.first }
        return duplicatesHandler.choseDuplicate(from: duplicates)
    }
    
    /// Transforms `[ A*: [A(1), A(2), A(7)], C*: [C(2), C(1)] ]` to `[A(x), C(y)]` where `x` and `y` are the
    /// selected associated values from the duplicates according to the DuplicatesHandler if any, or the default one.
    static func choseDuplicates(from duplicatesDictionary: [Attribute.Stripped: [Attribute]]) -> [Attribute] {
        return duplicatesDictionary.values.compactMap { Self.choseDuplicate(from: $0) }
    }
    
    static func removeDuplicatesIfNeededAndAble(_ attributes: [Attribute]) -> [Attribute] {
        let grouped = Self.groupAttributes(attributes)
        let duplicates = Dictionary(grouped.filter { $0.1.count > 1 })
        let selected = Self.choseDuplicates(from: duplicates)
        return selected + grouped.values.filter { $0.count == 1 }.flatMap { $0 }
    }
}

extension Attributed {

    /// Groups together attributes with same key returns those attributes which has
    /// duplicates values. Attributes with no duplicates are also returned, contained
    // in an array with the length of one. So given the attributes array:
    /// `[A(1), A(2), C(2), B(6), C(1), A(7)]` this method would return
    /// `[ A*: [A(1), A(2), A(7)], B*: [B(6)], C*: [C(2), C(1)] ]` where `X*` is the stripped representation
    /// of the attribute `X`.
    ///
    /// - Parameter attributes: Attributes array to process
    /// - Returns: dictionary where keys are stripped representation of attribute with duplicates. The value
    // for the key is an array of all Attribute(associatedValue).
    static func groupAttributes(_ attributes: [Attribute]) -> [Attribute.Stripped: [Attribute]] {
        var grouped: [Attribute.Stripped: [Attribute]] = [:]
        
        for attribute in attributes {
            let key = attribute.stripped
            var value = grouped[key] ?? []
            value.append(attribute)
            grouped[key] = value
        }
        return grouped
    }
}

//MARK: - ExpressibleByArrayLiteral
extension Attributed {
    public init(arrayLiteral elements: Attribute...) {
        self.init(Self.removeDuplicatesIfNeededAndAble(elements))
    }
}

public protocol MergeInterceptor {
    static func interceptMerge<A: Attributed>(master: A, slave: A) -> A
}

//MARK: - CustomStringConvertible
public extension Attributed {
    var description: String {
        var attributesAsString = [String]()
        for attribute in attributes {
            guard let value = attribute.associatedValue else { continue }
            attributesAsString.append("\(attribute.stripped.rawValue): \(value)")
        }
        return "[\(attributesAsString.joined(separator: ", "))]"
    }
}
