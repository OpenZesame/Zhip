//
//  UITextView_Extension.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

extension UITextView {
    convenience init(text: CustomStringConvertible) {
        self.init(frame: .zero)
        self.text = text.description
    }
}
