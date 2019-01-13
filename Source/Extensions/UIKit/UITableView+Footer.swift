//
//  UITableView+Footer.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-13.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

extension UITableView {
    func setFooterLabel(text: String, height: CGFloat = 44) {
        let footerView: FooterView

        if let tableFooterView = tableFooterView as? FooterView {
            footerView = tableFooterView
        } else {
            footerView = FooterView()
            let fittingSize = CGSize(width: bounds.width - (safeAreaInsets.left + safeAreaInsets.right), height: 0)
            let size = footerView.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            footerView.frame = CGRect(x: 0, y: 0, width: size.width, height: height)

            tableFooterView = footerView
        }

        footerView.updateLabel(text: text)
    }
}

extension Reactive where Base: UITableView {
    var footerLabel: Binder<String> {
        return Binder<String>(base) {
            $0.setFooterLabel(text: $1)
        }
    }
}
