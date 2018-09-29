//
//  VanillaLabelsViewController.swift
//  Example
//
//  Created by Alexander Cyon on 2017-06-02.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import UIKit

class VanillaLabelsViewController: UIViewController, StackViewOwner {
    
    private lazy var fooLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Foo"
        label.textColor = .red
        label.backgroundColor = .yellow
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    private lazy var barLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Bar"
        label.backgroundColor = .red
        label.textColor = .blue
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    private lazy var bazLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Baz"
        label.backgroundColor = .green
        label.textColor = .red
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 45)
        return label
    }()
    
    private lazy var attributedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = "This is an attributed string".applyAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)
            ], toSubstring: "attributed")
        label.backgroundColor = .purple
        label.textColor = .green
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.fooLabel, self.barLabel, self.bazLabel, self.attributedLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 50
        let margin: CGFloat = 40
        stackView.layoutMargins = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        stackView.self.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        title = "Vanilla - Labels"
    }
}
