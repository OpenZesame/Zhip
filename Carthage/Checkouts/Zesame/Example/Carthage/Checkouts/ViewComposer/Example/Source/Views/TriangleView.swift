//
//  TriangleView.swift
//  Example
//
//  Created by Alexander Cyon on 2017-06-02.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import UIKit
import ViewComposer

final class TriangleView: UIView, Composable {
    typealias StyleType = ViewStyle
    var fillColor: UIColor?
    var fillStyle: TriangleFillStyle?
    
    let style: ViewStyle
    init(_ style: ViewStyle? = nil) {
        let style = style.merge(slave: .default)
        self.style = style
        super.init(frame: .zero)
        compose(with: style)
    }
    
    required init(coder: NSCoder) { fatalError("needed by compiler") }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard
            let context = UIGraphicsGetCurrentContext(),
            let fillColor = fillColor,
            let fillStyle = fillStyle
        else {
            return
        }
        context.setFillColor(fillColor.cgColor)
        context.beginPath()
        draw(rect, in: context, with: fillStyle)
        context.closePath()
        context.fillPath()
    }
}

private extension TriangleView {
    func draw(_ rect: CGRect, in context: CGContext, with fillStyle: TriangleFillStyle) {
        switch fillStyle {
        case .lowerAcute:
            drawLowerAcute(rect, in: context)
        case .lowerGrave:
            drawLowerGrave(rect, in: context)
        case .upperAcute:
            drawUpperAcute(rect, in: context)
        case .upperGrave:
            drawUpperGrave(rect, in: context)
        }
    }
    
    // _Acute_ means this: ´ or even more clear: / and filling the lower half with the fillColor
    func drawLowerAcute(_ rect: CGRect, in context: CGContext) {
        context.move(to: CGPoint(x: 0, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: 0))
    }
    
    // _Grave_ means this: ` or even more clear: \ and filling the lower half with the fillColor
    func drawLowerGrave(_ rect: CGRect, in context: CGContext) {
        context.move(to: CGPoint(x: 0, y: 0))
        context.addLine(to: CGPoint(x: 0, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    }
    
    // _Acute_ means this: ´ or even more clear: / and filling the upper half with the fillColor
    func drawUpperAcute(_ rect: CGRect, in context: CGContext) {
        context.move(to: CGPoint(x: 0, y: 0))
        context.addLine(to: CGPoint(x: 0, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: 0))
        context.addLine(to: CGPoint(x: 0, y: 0))
    }
    
    // _Grave_ means this: ` or even more clear: \ and filling the upper half with the fillColor
    func drawUpperGrave(_ rect: CGRect, in context: CGContext) {
        context.move(to: CGPoint(x: 0, y: 0))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: 0))
        context.addLine(to: CGPoint(x: 0, y: 0))
    }
}

extension ViewStyle: CustomAttributeMerger {
    public typealias CustomAttribute = TriangleViewStyle
}

private extension Optional where Wrapped == ViewStyle {
    func merge(slave: Wrapped) -> Wrapped {
        guard let `self` = self else { return slave }
        return self.customMerge(slave: slave, into: self)
    }
}

private extension ViewStyle {
    static let `default`: ViewStyle = [.custom(TriangleViewStyle([.fillColor(.red), .fillStyle(.upperAcute)])), .color(.blue)]
}

public enum TriangleViewAttribute {
    case fillStyle(TriangleFillStyle)
    case fillColor(UIColor)
}

public enum TriangleFillStyle {
    case lowerAcute, lowerGrave, upperAcute, upperGrave
}

public struct TriangleViewStyle: Attributed {
    public static var customStyler: AnyCustomStyler<TriangleViewStyle>?
    public static var duplicatesHandler: AnyDuplicatesHandler<TriangleViewStyle>?

    public var startIndex: Int = 0
    public let attributes: [TriangleViewAttribute]
    
    public static var mergeInterceptors: [MergeInterceptor.Type] = []
    
    public init(attributes: [TriangleViewAttribute]) {
        self.attributes = attributes
    }
    
    public func install(on styleable: Any) {
        guard let triangleView = styleable as? TriangleView else { return }
        triangleView.apply(self)
    }
}

private extension TriangleView {
    func apply(_ style: TriangleViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .fillStyle(let fillStyle):
                self.fillStyle = fillStyle
            case .fillColor(let fillColor):
                self.fillColor = fillColor
            }
        }
        setNeedsDisplay()
    }
}

//MARK: Making TriangleViewAttribute AssociatedValueStrippable, typically we want to automate this using `Sourcery`...
extension TriangleViewAttribute: Equatable {
    public static func == (lhs: TriangleViewAttribute, rhs: TriangleViewAttribute) -> Bool {
        return lhs.stripped == rhs.stripped
    }
}

extension TriangleViewAttribute: AssociatedValueEnumExtractor {
    public var associatedValue: Any? {
        switch self {
        case .fillColor(let fillColor):
            return fillColor
        case .fillStyle(let fillStyle):
            return fillStyle
        }
    }
}

extension TriangleViewAttribute: AssociatedValueStrippable {
    public typealias Stripped = TriangleViewAttributeStripped
    public var stripped: Stripped {
        let stripped: Stripped
        switch self {
        case .fillColor:
            stripped = .fillColor
        case .fillStyle:
            stripped = .fillStyle
        }
        return stripped
    }
}

public enum TriangleViewAttributeStripped: String, StrippedRepresentation {
    case fillStyle, fillColor
}
