//
//  SimpleCustomAttributeViewController.swift
//  Example
//
//  Created by Alexander Cyon on 2017-06-03.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import UIKit
import ViewComposer


final class SimpleCustomAttributeViewController: UIViewController, StackViewOwner {
    
    private lazy var fooLabel: FooLabel = [.custom(FooStyle([.foo("Foobar")])), .textColor(.red), .color(.cyan)]
    lazy var stackView: UIStackView = [.views([self.fooLabel])]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        title = "ViewComposer - FooLabel"
    }
}
