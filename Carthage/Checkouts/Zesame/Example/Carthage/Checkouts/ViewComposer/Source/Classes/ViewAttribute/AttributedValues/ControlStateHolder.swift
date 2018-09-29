//
//  ControlStateHolder.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-31.
//
//

import Foundation

public protocol ControlStateHolder {
    func setControlStates(_ states: [ControlStateStyle])
}

extension UIButton: ControlStateHolder {
    @nonobjc public func setControlStates(_ states: [ControlStateStyle]) {
        ifNeededSetTitleForNonNormalStates(states)
        states.forEach {
            configureControlState($0)
        }
        ifNeededSetBorderColor(states)
    }
}

internal extension UIButton {
    func configureControlState(_ style: ControlStateStyle) {
        let state = style.state
        // important to call `setBackgroundColor` before `setImage`, since image should override.
        setBackgroundColor(style.backgroundColor, forState: state)
        setTitle(style.title, for: state)
        setTitleColor(style.titleColor, for: state)
        setImage(style.image, for: state)
    }
    
    func ifNeededSetBorderColor(_ styles: [ControlStateStyle]) {
        let normal = styles.filter({ $0.state == .normal }).first
        setBorderColor(normal?.borderColor)
    }
    
    @nonobjc func setBorderColor(_ borderColor: UIColor?) {
        guard let borderColor = borderColor else { return }
        setBorderColor(borderColor.cgColor)
    }
    
    @nonobjc func setBorderColor(_ borderColor: CGColor) {
        layer.borderColor = borderColor
    }
    
    func ifNeededSetTitleForNonNormalStates(_ states: [ControlStateStyle]) {
        guard let title = normalTitle(from: states) else { return }
        states.filter { $0.title == nil }.forEach { $0.title = title }
    }
    
    func normalTitle(from states: [ControlStateStyle]) -> String? {
        var normalTitle: String?
        for state in states {
            guard state is Normal else { continue }
            normalTitle = state.title
        }
        return normalTitle
    }

    func setBackgroundColor(_ color: UIColor?, forState state: UIControl.State) {
        guard let color = color else { return }
        setBackgroundImage(imageWithColor(color), for: state)
    }
}

fileprivate func imageWithColor(_ color: UIColor) -> UIImage {
    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    
    context?.setFillColor(color.cgColor)
    context?.fill(rect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image!
}
