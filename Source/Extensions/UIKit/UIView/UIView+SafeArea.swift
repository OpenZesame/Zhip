//
//  UIView+SafeArea.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-13.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import UIKit

extension UIView {
    func edgesToParent(topToSafeArea: Bool, bottomToSafeArea: Bool) {
        guard let superview = superview else { incorrectImplementation("Should have `superview`") }
        edgesTo(view: superview, topToSafeArea: topToSafeArea, bottomToSafeArea: bottomToSafeArea)
    }

    func edgesTo(view: UIView, topToSafeArea: Bool = true, bottomToSafeArea: Bool = true) {
        let topAnchor = topToSafeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor
        let bottomAnchor = bottomToSafeArea ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor

        [
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.topAnchor.constraint(equalTo: topAnchor),
            self.bottomAnchor.constraint(equalTo: bottomAnchor)
            ].forEach { $0.isActive = true }
    }
}
