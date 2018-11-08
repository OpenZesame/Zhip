//
//  ViewStyle.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-14.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

public class ViewStyle: ViewStyling {
    public let height: CGFloat?
    public let backgroundColor: UIColor?

    public init(height: CGFloat? = nil, backgroundColor: UIColor? = nil) {
        self.height = height
        self.backgroundColor = backgroundColor
    }
}
