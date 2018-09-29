//
//  UIImage+UIColor.swift
//  Example
//
//  Created by Alexander Cyon on 2017-06-22.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import UIKit

extension UIImage {
    static func withColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIColor {
    func toImage(sized size: CGSize) -> UIImage {
        return UIImage.withColor(self, size: size)
    }
}
