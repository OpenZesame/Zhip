//
//  OpenWalletController.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-05-26.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import ZilliqaSDK
import TinyConstraints
import RxSwift
import RxCocoa

extension UIView {
    static var spacer: UIView {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return spacer
    }
}
