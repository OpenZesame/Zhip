//
//  MergeInterceptors.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-25.
//
//

import Foundation

import XCTest
@testable import ViewComposer

class MergeInterceptorsTests: BaseXCTest {
        
    func testCustomAttributeMergingOperator() {
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let baseStyle: ViewStyle = [.foo(fooText)]
        let style: ViewStyle = baseStyle <<- .bar(bar)
        guard let foobarViewStyle: FooBarViewStyle = style.value(.custom) else { XCTAssert(false); return }
        XCTAssert(foobarViewStyle.count == 2)
        XCTAssert(foobarViewStyle.value(.bar) == bar)
        XCTAssert(foobarViewStyle.value(.foo) == fooText)
    }
    
    func testCustomAttributeMergingIntercepting() {
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let baseStyle: ViewStyle = [.foo(fooText)]
        let style: ViewStyle = baseStyle.merge(master: .bar(bar))
        guard let foobarViewStyle: FooBarViewStyle = style.value(.custom) else { XCTAssert(false); return }
        XCTAssert(foobarViewStyle.count == 2)
        XCTAssert(foobarViewStyle.value(.bar) == bar)
        XCTAssert(foobarViewStyle.value(.foo) == fooText)
    }
    
    
    let bar = 237
    func testCustomAttributeMergingNotIntercepting() {
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let baseStyle: ViewStyle = [.foo(fooText)]
        let style: ViewStyle = baseStyle.merge(master: .bar(bar), intercept: false)
        guard let foobarViewStyle: FooBarViewStyle = style.value(.custom) else { XCTAssert(false); return }
        XCTAssert(foobarViewStyle.count == 1)
        XCTAssert(foobarViewStyle.value(.bar) == bar)
    }
    
    func testMasterMergeBetweenEmptyArrayAndDuplicatedCustomAttributesArray() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let empty = [ViewAttribute]()
        let merged: ViewStyle = empty.merge(master: [.bar(bar), .foo(fooText)])
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssert(style.count == 2)
        XCTAssert(style.value(.bar) == bar)
        XCTAssert(style.value(.foo) == fooText)
    }
    
    func testMasterMergeBetweenEmptyStyleAndDuplicatedCustomAttributesArray() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let merged: ViewStyle = ViewStyle([]).merge(master: [.bar(bar), .foo(fooText)])
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssert(style.count == 2)
        XCTAssert(style.value(.bar) == bar)
        XCTAssert(style.value(.foo) == fooText)
    }
    
    func testMasterMergeBetweenEmptyArrayAndDuplicatedCustomAttributesStyle() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let empty = [ViewAttribute]()
        let merged: ViewStyle = empty.merge(master: ViewStyle([.bar(bar), .foo(fooText)]))
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssert(style.count == 2)
        XCTAssert(style.value(.bar) == bar)
        XCTAssert(style.value(.foo) == fooText)
    }
    
    func testMasterMergeBetweenEmptyStyleAndDuplicatedCustomAttributesStyle() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let merged: ViewStyle = ViewStyle([]).merge(master: ViewStyle([.bar(bar), .foo(fooText)]))
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssert(style.count == 2)
        XCTAssert(style.value(.bar) == bar)
        XCTAssert(style.value(.foo) == fooText)
    }
    
    //Using slave
    func testSlaveCustomAttributeMergingNotIntercepting() {
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let baseStyle: ViewStyle = [.foo(fooText)]
        let style: ViewStyle = baseStyle.merge(slave: .bar(bar), intercept: false)
        print("style: `\(style)`")
        guard let foobarViewStyle: FooBarViewStyle = style.value(.custom) else { XCTAssert(false); return }
        XCTAssert(foobarViewStyle.count == 1)
        XCTAssert(foobarViewStyle.value(.foo) == fooText)
    }
    
    func testSlaveMergeBetweenEmptyArrayAndDuplicatedCustomAttributesArray() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let empty = [ViewAttribute]()
        let merged: ViewStyle = empty.merge(slave: [.bar(bar), .foo(fooText)])
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssert(style.count == 2)
        XCTAssert(style.value(.bar) == bar)
        XCTAssert(style.value(.foo) == fooText)
    }
    
    func testSlaveMergeBetweenEmptyStyleAndDuplicatedCustomAttributesArray() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let merged: ViewStyle = ViewStyle([]).merge(slave: [.bar(bar), .foo(fooText)])
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssert(style.count == 2)
        XCTAssert(style.value(.bar) == bar)
        XCTAssert(style.value(.foo) == fooText)
    }
    
    func testSlaveMergeBetweenEmptyArrayAndDuplicatedCustomAttributesStyle() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let empty = [ViewAttribute]()
        let merged: ViewStyle = empty.merge(slave: ViewStyle([.bar(bar), .foo(fooText)]))
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssert(style.count == 2)
        XCTAssert(style.value(.bar) == bar)
        XCTAssert(style.value(.foo) == fooText)
    }
    
    func testSlaveMergeBetweenEmptyStyleAndDuplicatedCustomAttributesStyle() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let merged: ViewStyle = ViewStyle([]).merge(slave: ViewStyle([.bar(bar), .foo(fooText)]))
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssert(style.count == 2)
        XCTAssert(style.value(.bar) == bar)
        XCTAssert(style.value(.foo) == fooText)
    }
    
    //MARK: - Using operators
    func testMasterMergeOperatorBetweenEmptyArrayAndDuplicatedCustomAttributesArray() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let empty = [ViewAttribute]()
        let merged: ViewStyle = empty <<- [.bar(bar), .foo(fooText)]
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssert(style.count == 2)
        XCTAssert(style.value(.bar) == bar)
        XCTAssert(style.value(.foo) == fooText)
    }
    
    func testMasterMergeOperatorBetweenEmptyStyleAndDuplicatedCustomAttributesArray() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let merged: ViewStyle = ViewStyle([]) <<- [.bar(bar), .foo(fooText)]
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssert(style.count == 2)
        XCTAssert(style.value(.bar) == bar)
        XCTAssert(style.value(.foo) == fooText)
    }
    
    func testMasterMergeOperatorBetweenEmptyArrayAndDuplicatedCustomAttributesStyle() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let empty = [ViewAttribute]()
        let merged: ViewStyle = empty <<- ViewStyle([.bar(bar), .foo(fooText)])
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssert(style.count == 2)
        XCTAssert(style.value(.bar) == bar)
        XCTAssert(style.value(.foo) == fooText)
    }
    
    func testMasterMergeOperatorBetweenEmptyStyleAndDuplicatedCustomAttributesStyle() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let merged: ViewStyle = ViewStyle([]) <<- ViewStyle([.bar(bar), .foo(fooText)])
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssert(style.count == 2)
        XCTAssert(style.value(.bar) == bar)
        XCTAssert(style.value(.foo) == fooText)
    }
    
    //Using slave
    func testSlaveMergeOperatorBetweenEmptyArrayAndDuplicatedCustomAttributesArray() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let empty = [ViewAttribute]()
        let merged: ViewStyle = empty <- [.bar(bar), .foo(fooText)]
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssert(style.count == 2)
        XCTAssert(style.value(.bar) == bar)
        XCTAssert(style.value(.foo) == fooText)
    }
    
    func testSlaveMergeOperatorBetweenEmptyStyleAndDuplicatedCustomAttributesArray() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let merged: ViewStyle = ViewStyle([]) <- [.bar(bar), .foo(fooText)]
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssert(style.count == 2)
        XCTAssert(style.value(.bar) == bar)
        XCTAssert(style.value(.foo) == fooText)
    }
    
    func testSlaveMergeOperatorBetweenEmptyArrayAndDuplicatedCustomAttributesStyle() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let empty = [ViewAttribute]()
        let merged: ViewStyle = empty <- ViewStyle([.bar(bar), .foo(fooText)])
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssert(style.count == 2)
        XCTAssert(style.value(.bar) == bar)
        XCTAssert(style.value(.foo) == fooText)
    }
    
    func testSlaveMergeOperatorBetweenEmptyStyleAndDuplicatedCustomAttributesStyle() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let merged: ViewStyle = ViewStyle([]) <- ViewStyle([.bar(bar), .foo(fooText)])
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssert(style.count == 2)
        XCTAssert(style.value(.bar) == bar)
        XCTAssert(style.value(.foo) == fooText)
    }

    //MARK Single operator
    func testMasterMergeOperatorBetweenSingleAttributes() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let merged: ViewStyle =  .bar(bar) <<- .foo(fooText)
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssert(style.count == 2)
        XCTAssert(style.value(.bar) == bar)
        XCTAssert(style.value(.foo) == fooText)
    }
    
    func testMasterMergeOperatorBetweenTwoArrays() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let merged: ViewStyle =  [.bar(bar)] <<- [.foo(fooText)]
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssert(style.count == 2)
        XCTAssert(style.value(.bar) == bar)
        XCTAssert(style.value(.foo) == fooText)
    }
    
    //using slave
    func testSlaveMergeOperatorBetweenSingleAttributes() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let merged: ViewStyle =  .bar(bar) <- .foo(fooText)
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssert(style.count == 2)
        XCTAssert(style.value(.bar) == bar)
        XCTAssert(style.value(.foo) == fooText)
    }
    
    func testSlaveMergeOperatorBetweenTwoArrays() {
        ViewStyle.duplicatesHandler = AnyDuplicatesHandler(FoobarViewAttributeDuplicatesHandler())
        ViewStyle.mergeInterceptors.append(FooBarViewAttributeMerger.self)
        let merged: ViewStyle =  [.bar(bar)] <- [.foo(fooText)]
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssert(style.count == 2)
        XCTAssert(style.value(.bar) == bar)
        XCTAssert(style.value(.foo) == fooText)
    }
    
    func testSlaveMergeOperatorBetweenSingleAttributesFailesWithoutInterceptor() {
        let merged: ViewStyle =  .bar(bar) <- .foo(fooText)
        guard let style: FooBarViewStyle = merged.value(.custom) else { XCTAssert(false); return }
        XCTAssertFalse(style.count == 2) // fails since no interceptor passed in
    }
}

struct FooBarViewAttributeMerger: MergeInterceptor {
    static func interceptMerge<A>(master masterAttributed: A, slave slaveAttributed: A) -> A where A : Attributed {
        guard
            let master = masterAttributed as? ViewStyle,
            let slave = slaveAttributed as? ViewStyle,
            let masterFooBar: FooBarViewStyle = master.value(.custom),
            let slaveFooBar: FooBarViewStyle = slave.value(.custom)
            else { return masterAttributed.merge(slave: slaveAttributed, intercept: false) }
        let merged = masterFooBar.merge(slave: slaveFooBar, intercept: false)
        return ViewStyle([.custom(merged)]) as! A
    }
}

public enum FooBarViewAttribute {
    case foo(String)
    case bar(Int)
}

protocol FooBarViewStyleable {
    var foo: String? { get set }
    var bar: Int? { get set }
}

extension UITextField: FooBarViewStyleable {
    
    var foo: String? {
        set { placeholder = newValue }
        get { return placeholder }
    }
    
    var bar: Int? {
        set { text = "\(newValue!)" }
        get {
            guard let text = text else { return nil }
            return Int(text)
        }
    }
}

extension ViewAttribute {
    static func foo(_ foo: String) -> ViewAttribute {
        return .foobar(.foo(foo))
    }
    
    static func bar(_ bar: Int) -> ViewAttribute {
        return .foobar(.bar(bar))
    }
    
    static func foobar(_ attribute: FooBarViewAttribute) -> ViewAttribute {
        return .custom(FooBarViewStyle([attribute]))
    }
}

public struct FooBarViewStyle: Attributed {
    public static var customStyler: AnyCustomStyler<FooBarViewStyle>?
    public static var mergeInterceptors: [MergeInterceptor.Type] = []
    public static var duplicatesHandler: AnyDuplicatesHandler<FooBarViewStyle>?
    
    public var startIndex: Int = 0
    public let attributes: [FooBarViewAttribute]
    
    public init(attributes: [FooBarViewAttribute]) {
        self.attributes = attributes
    }
    
    public init(arrayLiteral elements: FooBarViewAttribute...) {
        self.attributes = elements
    }
    
    public func install(on styleable: Any) {
        guard var fooBarStyleable = styleable as? FooBarViewStyleable else { return }
        attributes.forEach {
            switch $0 {
            case .foo(let foo):
                fooBarStyleable.foo = foo
            case .bar(let bar):
                fooBarStyleable.bar = bar
            }
        }
    }
}

//MARK: Making FooBarViewAttribute AssociatedValueStrippable, typically we want to automate this using `Sourcery`...
extension FooBarViewAttribute: Equatable {
    public static func == (lhs: FooBarViewAttribute, rhs: FooBarViewAttribute) -> Bool {
        return lhs.stripped == rhs.stripped
    }
}

extension FooBarViewAttribute: AssociatedValueEnumExtractor {
    public var associatedValue: Any? {
        switch self {
        case .foo(let foo):
            return foo
        case .bar(let bar):
            return bar
        }
    }
}

extension FooBarViewAttribute: AssociatedValueStrippable {
    public typealias Stripped = FooBarViewAttributeStripped
    public var stripped: Stripped {
        let stripped: Stripped
        switch self {
        case .foo:
            stripped = .foo
        case .bar:
            stripped = .bar
        }
        return stripped
    }
}

public enum FooBarViewAttributeStripped: String, StrippedRepresentation {
    case foo, bar
}

