//
//  ImageConvertible.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

protocol ImageConvertible {
    var image: UIImage { get }
}

extension UIImage: ImageConvertible {
    var image: UIImage { return self }
}

extension ImageAsset: ImageConvertible {}
