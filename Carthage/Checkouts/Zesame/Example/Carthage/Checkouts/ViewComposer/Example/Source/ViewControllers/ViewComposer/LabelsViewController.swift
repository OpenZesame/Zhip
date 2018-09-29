//
//  LabelsViewController.swift
//  Example
//
//  Created by Alexander Cyon on 2017-06-01.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import UIKit
import ViewComposer

private let labelStyle: ViewStyle = [.textColor(.red), .textAlignment(.center), .font(.boldSystemFont(ofSize: 30)), .color(.yellow)]
class LabelsViewController: UIViewController, StackViewOwner {
    
    private lazy var fooLabel: UILabel = labelStyle <<- .text("Foo")
    private lazy var barLabel: UILabel = labelStyle <<- [.text("Bar"), .textColor(.blue), .color(.red)]
    private lazy var bazLabel: UILabel = labelStyle <<- [.text("Baz"), .textAlignment(.left), .color(.green), .font(.boldSystemFont(ofSize: 45))]
    private lazy var attributedText: NSAttributedString = "This is an attributed string".applyAttributes([
        NSAttributedString.Key.foregroundColor: UIColor.red,
        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)
        ], toSubstring: "attributed")
    private lazy var attributedLabel: UILabel = labelStyle <<- [.font(.boldSystemFont(ofSize: 14)), .textColor(.green), .color(.purple), .attributedText(self.attributedText)]
    
    lazy var stackView: UIStackView = StackView([.views([self.fooLabel, self.barLabel, self.bazLabel, self.attributedLabel]), .distribution(.fillEqually), .color(.blue), .spacing(50), .layoutMargins(all: 40), .marginsRelative(true)])
    
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
        title = "ViewComposer - Labels"
    }
}
