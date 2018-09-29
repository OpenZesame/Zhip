//
//  TextHolder.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-31.
//
//

import Foundation

public protocol TextHolder: class {
    var textProxy: String? { get set }
    var textColorProxy: UIColor? { get set }
    var fontProxy: UIFont? { get set }
    var textAlignmentProxy: NSTextAlignment { get set }
    func setCase(_ `case`: Case)
}

public protocol NativeTextHolder: class {
    var text: String? { get set }
}

public protocol NativeTextAlignmentHolder: class {
    var textAlignment: NSTextAlignment { get set }
}

public protocol NativeTextColorHolder: class {
    var textColor: UIColor? { get set }
}

public protocol NativeFontHolder: class {
    var font: UIFont? { get set }
}

extension TextHolder where Self: NativeTextHolder {
    public var textProxy: String? {
        get { return text }
        set { text = newValue }
    }
}

extension TextHolder where Self: NativeTextAlignmentHolder {
    public var textAlignmentProxy: NSTextAlignment {
        get { return textAlignment }
        set { textAlignment = newValue }
    }
}

extension TextHolder where Self: NativeTextColorHolder {
    public var textColorProxy: UIColor? {
        get { return textColor }
        set { textColor = newValue }
    }
}

extension TextHolder where Self: NativeFontHolder {
    public var fontProxy: UIFont? {
        get { return font }
        set { font = newValue }
    }
}

internal extension TextHolder {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .font(let font):
                fontProxy = font
            case .textColor(let textColor):
                textColorProxy = textColor
            case .text(let text):
                textProxy = text
            case .textAlignment(let textAlignment):
                textAlignmentProxy = textAlignment
            case .case(let `case`):
                setCase(`case`)
            default:
                break
            }
        }
    }
}

public extension TextHolder {
    func setCase(_ `case`: Case) {
        textProxy = `case`.apply(to: textProxy)
    }
}

extension UILabel: NativeTextHolder {}
extension UILabel: NativeTextAlignmentHolder {}
extension UILabel: TextHolder {
    public var textColorProxy: UIColor? {
        get { return textColor }
        set { textColor = newValue }
    }
    
    public var fontProxy: UIFont? {
        get { return font }
        set { font = newValue }
    }
}

extension UITextField: NativeTextColorHolder {}
extension UITextField: NativeTextAlignmentHolder {}
extension UITextField: NativeFontHolder {}
extension UITextField: TextHolder {
    public var textProxy: String? {
        get { return text }
        set { text = newValue }
    }
}

extension UITextView: NativeTextColorHolder {}
extension UITextView: NativeTextAlignmentHolder {}
extension UITextView: NativeFontHolder {}
extension UITextView: TextHolder {
    public var textProxy: String? {
        get { return text }
        set { text = newValue }
    }
}

extension UIButton: TextHolder {
    public var textAlignmentProxy: NSTextAlignment {
        get { guard let label = titleLabel else { return .left }; return label.textAlignment }
        set { titleLabel?.textAlignment = newValue }
    }
    
    public var fontProxy: UIFont? {
        get { return titleLabel?.font }
        set { titleLabel?.font = newValue }
    }
    
    public var textProxy: String? {
        get { return titleLabel?.text }
        set { setTitle(newValue, for: .normal) }
    }
    
    public var textColorProxy: UIColor? {
        get { return titleLabel?.textColor }
        set { setTitleColor(newValue, for: .normal) }
    }
}

extension UISearchBar: TextHolder {
    public var textAlignmentProxy: NSTextAlignment {
        get { return UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textAlignment }
        set { /* nothing to do */ }
    }
    
    public var fontProxy: UIFont? {
        get { return UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font }
        set { /* nothing to do */ }
    }
    
    public var textProxy: String? {
        get { return text }
        set { text = newValue }
    }
    
    public var textColorProxy: UIColor? {
        get { return UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor }
        set { /* nothing to do */ }
    }
}
