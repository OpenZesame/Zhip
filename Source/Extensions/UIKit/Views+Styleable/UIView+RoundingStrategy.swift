//
//  UIView+RoundingStrategy.swift
//  Zupreme
//
//  Created by Alexander Cyon on 13/11/2018.
//  Modified by Andrei Radulescu on 19/11/2018.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

private var roundingStrategyBagKey: UInt8 = 0

extension UIView {
    enum RoundingStrategy {
        case dynamic(Dynamic)
        case `static`(CGFloat)
        enum Dynamic {
            case basedOnHeight
        }
    }
    
    var roundingStrategyBag: DisposeBag {
        get {
            return associatedObject(self, key: &roundingStrategyBagKey) { return DisposeBag() }
        }
        set {
            associateObject(self, key: &roundingStrategyBagKey, value: newValue)
        }
    }
    
    func addRoundingStrategy(_ roundingStrategy: RoundingStrategy = .default) {
        self.rx.sentMessage(#selector(UIView.layoutSubviews))
            .subscribe({ e in
                self.roundCorners(using: roundingStrategy)
            })
            .disposed(by: roundingStrategyBag)
    }
    
    // This is being called in `layoutSubviews()`
    func roundCorners(using strategy: RoundingStrategy) {
        let cornerRadius: CGFloat
        defer {
            layer.cornerRadius = cornerRadius
        }
        switch strategy {
        case .static(let radius): cornerRadius = radius
        case .dynamic(let dynamic):
            switch dynamic {
            case .basedOnHeight: cornerRadius = frame.height/2
            }
        }
    }
}

extension UIView.RoundingStrategy {
    static var `default`: UIView.RoundingStrategy {
        return .dynamic(.basedOnHeight)
    }
}
