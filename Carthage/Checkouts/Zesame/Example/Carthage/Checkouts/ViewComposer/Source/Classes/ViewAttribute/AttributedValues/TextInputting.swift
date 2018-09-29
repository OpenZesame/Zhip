//
//  TextInputting.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-10.
//
//

import Foundation

public protocol TextInputting: AnyObject {
    var isEditable: Bool { get set } //used by `UITextView` but not by `UITextField`
    var clearsOnBeginEditing: Bool { get set } //used by `UITextField` but not by `UITextView`
    var clearsOnInsertion: Bool { get set }
    var inputView: UIView? { get set }
    var inputAccessoryView: UIView? { get set }
    var allowsEditingTextAttributes: Bool { get set }
    var typingAttributesProxy: [NSAttributedString.Key: Any]? { get set }
}

extension UITextField: TextInputting {
    public var isEditable: Bool {
        get { return false }
        set { /* ignored */}
    }
    
    public var typingAttributesProxy: [NSAttributedString.Key: Any]? {
        get { return typingAttributes }
        set { typingAttributes = newValue }
    }
}

extension UITextView: TextInputting {
    public var clearsOnBeginEditing: Bool {
        get { return false }
        set { /* ignored */}
    }
    
    public var typingAttributesProxy: [NSAttributedString.Key: Any]? {
        get { return typingAttributes }
        set {
            guard let attributes = newValue else { typingAttributes = [:]; return }
            typingAttributes = attributes
        }
    }
}
internal extension TextInputting {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .editable(let editable):
                self.isEditable = editable
            case .clearsOnInsertion(let clearsOnInsertion):
                self.clearsOnInsertion = clearsOnInsertion
            case .clearsOnBeginEditing(let clearsOnBeginEditing):
                self.clearsOnBeginEditing = clearsOnBeginEditing
            case .inputView(let view):
                inputView = view
            case .inputAccessoryView(let view):
                inputAccessoryView = view
            case .allowsEditingTextAttributes(let allows):
                allowsEditingTextAttributes = allows
            case .typingAttributes(let attributes):
                typingAttributesProxy = attributes
            default:
                break
            }
        }
    }
}
