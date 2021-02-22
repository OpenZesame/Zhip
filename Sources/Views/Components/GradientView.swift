//
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
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

import UIKit

public typealias GradientType = (x: CGPoint, y: CGPoint)

// Cred goes to: https://medium.com/ios-os-x-development/swift-3-easy-gradients-54ccc9284ce4
public enum GradientPoint {
    case leftToRight
    case rightToLeft
    case topToBottom
    case bottomToTop
    case topLeftToBottomRight
    case bottomRightToTopLeft
    case topRightToBottomLeft
    case bottomLeftToTopRight

    // swiftlint:disable:next function_body_length
    func draw() -> GradientType {
        switch self {
        case .leftToRight:
            return (x: CGPoint(x: 0, y: 0.5), y: CGPoint(x: 1, y: 0.5))
        case .rightToLeft:
            return (x: CGPoint(x: 1, y: 0.5), y: CGPoint(x: 0, y: 0.5))
        case .topToBottom:
            return (x: CGPoint(x: 0.5, y: 0), y: CGPoint(x: 0.5, y: 1))
        case .bottomToTop:
            return (x: CGPoint(x: 0.5, y: 1), y: CGPoint(x: 0.5, y: 0))
        case .topLeftToBottomRight:
            return (x: CGPoint(x: 0, y: 0), y: CGPoint(x: 1, y: 1))
        case .bottomRightToTopLeft:
            return (x: CGPoint(x: 1, y: 1), y: CGPoint(x: 0, y: 0))
        case .topRightToBottomLeft:
            return (x: CGPoint(x: 1, y: 0), y: CGPoint(x: 0, y: 1))
        case .bottomLeftToTopRight:
            return (x: CGPoint(x: 0, y: 1), y: CGPoint(x: 1, y: 0))
        }
    }
}

public class GradientLayer: CAGradientLayer {
    public var gradient: GradientType? {
        didSet {
            startPoint = gradient?.x ?? CGPoint.zero
            endPoint = gradient?.y ?? CGPoint.zero
        }
    }
}

public class GradientView: UIView {

    public static var defaultColors: [UIColor] = [
        UIColor.teal.withAlphaComponent(0.25),
        UIColor.teal.withAlphaComponent(0.1),
        UIColor.deepBlue.withAlphaComponent(0.3),
        UIColor.deepBlue.withAlphaComponent(0.7),
        UIColor.deepBlue.withAlphaComponent(0.9)
    ]

    public let direction: GradientPoint

    public init(direction: GradientPoint = .topToBottom, colors: [UIColor]? = nil) {
        self.direction = direction
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        gradientLayer.colors = (colors ?? GradientView.defaultColors).map { $0.cgColor }
        gradientLayer.gradient = direction.draw()
    }

    public required init?(coder: NSCoder) { interfaceBuilderSucks }

    override public class var layerClass: Swift.AnyClass {
        return GradientLayer.self
    }
}

public extension GradientView {
    func updateColors(_ colors: [UIColor], withAlphaComponent alpha: CGFloat? = nil) {
        var colors = colors
        if let alpha = alpha {
            colors = colors.map { $0.withAlphaComponent(alpha) }
        }
        gradientLayer.colors = colors.map { $0.cgColor  }
        gradientLayer.gradient = direction.draw()
    }
}

public protocol GradientViewProvider {
    associatedtype GradientViewType
}

public extension GradientViewProvider where Self: GradientView {
    var gradientLayer: Self.GradientViewType {
        // swiftlint:disable:next force_cast
        return layer as! Self.GradientViewType
    }
}

extension GradientView: GradientViewProvider {
    public typealias GradientViewType = GradientLayer
}
