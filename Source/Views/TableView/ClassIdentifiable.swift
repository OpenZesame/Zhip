//
//  ClassIdentifiable.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-19.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

protocol ClassIdentifiable: NSObjectProtocol {
    static var className: String { get }
}

protocol Identifiable {
    static var identifier: String { get }
}

extension Identifiable where Self: ClassIdentifiable {
    static var identifier: String { return className }
}

extension UITableViewCell: Identifiable {}

extension NSObject: ClassIdentifiable {
    static var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
