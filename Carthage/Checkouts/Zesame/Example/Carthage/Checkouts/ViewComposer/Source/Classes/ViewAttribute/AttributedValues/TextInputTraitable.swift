//
//  TextInputTraitable.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-07-03.
//
//

import Foundation

protocol TextInputTraitable: class {
    var autocapitalizationType: UITextAutocapitalizationType { get set }
    var autocorrectionType: UITextAutocorrectionType { get set }
    var spellCheckingType: UITextSpellCheckingType { get set }
    var keyboardType: UIKeyboardType { get set }
    var keyboardAppearance: UIKeyboardAppearance { get set }
    var returnKeyType: UIReturnKeyType { get set }
    var enablesReturnKeyAutomatically: Bool { get set }
    var isSecureTextEntry: Bool { get set }
    var textContentTypeProxy: UITextContentType? { get set }
}

extension UITextField: TextInputTraitable {
    var textContentTypeProxy: UITextContentType? {
        get {
            guard #available(iOS 10.0, *) else { return nil }
            return textContentType
        }
        
        set {
            guard #available(iOS 10.0, *) else { return }
            textContentType = newValue
        }
    }
}

extension UITextView: TextInputTraitable {
    var textContentTypeProxy: UITextContentType? {
        get {
            guard #available(iOS 10.0, *) else { return nil }
            return textContentType
        }
        
        set {
            guard #available(iOS 10.0, *) else { return }
            textContentType = newValue
        }
    }
}

extension UISearchBar: TextInputTraitable {
    var textContentTypeProxy: UITextContentType? {
        get {
            guard #available(iOS 10.0, *) else { return nil }
            return textContentType
        }
        
        set {
            guard #available(iOS 10.0, *) else { return }
            textContentType = newValue
        }
    }
}

internal extension TextInputTraitable {
    func apply(_ style: ViewStyle) {
        style.attributes.forEach {
            switch $0 {
            case .autocapitalizationType(let type):
                autocapitalizationType = type
            case .autocorrectionType(let type):
                autocorrectionType = type
            case .spellCheckingType(let type):
                spellCheckingType = type
            case .keyboardType(let type):
                keyboardType = type
            case .keyboardAppearance(let appearance):
                keyboardAppearance = appearance
            case .returnKeyType(let type):
                returnKeyType = type
            case .enablesReturnKeyAutomatically(let enables):
                enablesReturnKeyAutomatically = enables
            case .isSecureTextEntry(let isSecure):
                isSecureTextEntry = isSecure
            case .textContentType(let type):
                textContentTypeProxy = type
            default:
                break
            }
        }
    }
}
