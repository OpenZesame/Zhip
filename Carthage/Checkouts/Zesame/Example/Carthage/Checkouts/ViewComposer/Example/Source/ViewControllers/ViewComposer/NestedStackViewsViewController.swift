//
//  NestedStackViewsViewController.swift
//  ViewComposer-Example
//
//  Created by Alexander Cyon on 2017-05-30.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import UIKit
import ViewComposer

class NestedStackViewsViewController: UIViewController, StackViewOwner {
    
    lazy var fooLabel: UILabel = [.text("Foo"), .textColor(.blue), .color(.red), .textAlignment(.center)]
    lazy var barLabel: UILabel =  [.text("Bar"), .textColor(.red), .color(.green), .textAlignment(.center)]
    lazy var labels: UIStackView = [.views([self.fooLabel, self.barLabel]), .distribution(.fillEqually)]
    
    lazy var button: UIButton = [.text("Baz"), .color(.cyan), .textColor(.red)]
    
    lazy var stackView: UIStackView = [.views([self.labels, self.button]), .axis(.vertical), .distribution(.fillEqually)]
    
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
        title = "ViewComposer - Nested StackViews"
    }
}
