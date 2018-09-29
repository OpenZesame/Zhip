//
//  StackViewOwner.swift
//  Example
//
//  Created by Alexander Cyon on 2017-06-11.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import UIKit
import ViewComposer

protocol SingleSubviewOwner {
    associatedtype SubviewType: UIView
    var subview: SubviewType { get }
    var parentView: UIView { get }
    func specialConfig()
}

extension SingleSubviewOwner {
    func specialConfig() {}
}


extension SingleSubviewOwner where Self: UIViewController {
    var parentView: UIView { return self.view }
    
    func specialConfig() {
        view.backgroundColor = .white
        edgesForExtendedLayout = []
        automaticallyAdjustsScrollViewInsets = false
    }
}

extension SingleSubviewOwner {
    func setupViews() {
        parentView.addSubview(subview)
        parentView.addConstraint(subview.topAnchor.constraint(equalTo: parentView.topAnchor))
        parentView.addConstraint(subview.leadingAnchor.constraint(equalTo: parentView.leadingAnchor))
        parentView.addConstraint(subview.trailingAnchor.constraint(equalTo: parentView.trailingAnchor))
        let bottom = subview.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        bottom.priority = .defaultHigh
        parentView.addConstraint(bottom)
        
        specialConfig()
    }
}
