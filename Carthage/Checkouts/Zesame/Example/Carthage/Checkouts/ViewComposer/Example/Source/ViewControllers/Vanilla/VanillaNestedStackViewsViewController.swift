//
//  VanillaNestedStackViewsViewController.swift
//  Example
//
//  Created by Alexander Cyon on 2017-06-01.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import UIKit

class VanillaNestedStackViewsViewController: UIViewController, StackViewOwner {
    
    lazy var fooLabel: UILabel = {
        let fooLabel = UILabel()
        fooLabel.translatesAutoresizingMaskIntoConstraints = false
        fooLabel.text = "Foo"
        fooLabel.textColor = .blue
        fooLabel.backgroundColor = .red
        fooLabel.textAlignment = .center
        return fooLabel
    }()
    
    lazy var barLabel: UILabel = {
        let barLabel = UILabel()
        barLabel.translatesAutoresizingMaskIntoConstraints = false
        barLabel.text = "Bar"
        barLabel.textColor = .red
        barLabel.backgroundColor = .green
        barLabel.textAlignment = .center
        return barLabel
    }()
    
    lazy var labels: UIStackView = {
        let labels = UIStackView(arrangedSubviews: [self.fooLabel, self.barLabel])
        labels.translatesAutoresizingMaskIntoConstraints = false
        labels.distribution = .fillEqually
        return labels
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .cyan
        button.setTitle("Baz", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.labels, self.button, self.button])
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
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
        title = "Vanilla - Nested StackViews"
    }
}
