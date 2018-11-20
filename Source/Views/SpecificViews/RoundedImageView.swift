//
//  RoundedImageView.swift
//  Zupreme
//
//  Created by Andrei Radulescu on 20/11/2018.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

final class RoundedImageView: UIImageView {
    enum RoundedBy {
        case height
    }
    
    private let roundedBy: RoundedBy
    
    init(_ roundedBy: RoundedBy = .height) {
        self.roundedBy = roundedBy
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) { interfaceBuilderSucks }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(roundedBy)
    }
}

private extension RoundedImageView {
    func roundCorners(_ roundedBy: RoundedBy) {
        let cornerRadius: CGFloat
        defer {
            layer.cornerRadius = cornerRadius
        }
        switch roundedBy {
        case .height: cornerRadius = frame.height/2
        }
    }
}
