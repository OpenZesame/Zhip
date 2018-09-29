//
//  Validating.swift
//  Example
//
//  Created by Alexander Cyon on 2017-06-11.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import UIKit

protocol Validating {
    associatedtype ValidationData
    var validationData: ValidationData? { get }
    
    func validate()
    var isValid: Bool { get }
}

extension UITextField: Validating {
    
    typealias ValidationData = String
    var validationData: ValidationData? { return text }
    
    func validate() {
        let borderColor: UIColor = isValid ? .green : .red
        layer.borderColor = borderColor.cgColor
    }
    
    var isValid: Bool {
        guard let data = validationData, !data.isEmpty else { return false }
        return true
    }
}
