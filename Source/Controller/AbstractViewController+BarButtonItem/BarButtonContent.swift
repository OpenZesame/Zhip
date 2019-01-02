//
//  BarButtonContent.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

struct BarButtonContent {
    enum ButtontType {
        case text(String)
        case image(UIImage)
        case system(UIBarButtonItem.SystemItem)
    }
    let type: ButtontType
    let style: UIBarButtonItem.Style?

    init(type: ButtontType, style: UIBarButtonItem.Style? = .plain) {
        self.type = type
        self.style = style
    }

    init(title: CustomStringConvertible, style: UIBarButtonItem.Style = .plain) {
        self.init(type: .text(title.description))
    }

    init(image: ImageConvertible, style: UIBarButtonItem.Style = .plain) {
        self.init(type: .image(image.image))
    }

    init(system: UIBarButtonItem.SystemItem) {
        self.init(type: .system(system))
    }
}

// MARK: - UIBarButtonItem
extension BarButtonContent {
    func makeBarButtonItem<Target>(target: Target, selector: Selector) -> UIBarButtonItem {
        switch type {
        case .image(let image): return UIBarButtonItem(image: image, style: style ?? .plain, target: target, action: selector)
        case .text(let text): return UIBarButtonItem(title: text, style: style ?? .plain, target: target, action: selector)
        case .system(let system): return UIBarButtonItem(barButtonSystemItem: system, target: target, action: selector)
        }
    }
}
