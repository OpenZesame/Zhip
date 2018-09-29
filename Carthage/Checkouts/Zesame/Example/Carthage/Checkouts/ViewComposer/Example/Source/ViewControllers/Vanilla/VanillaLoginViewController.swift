//
//  VanillaLoginViewController.swift
//  Example
//
//  Created by Alexander Cyon on 2017-06-11.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import UIKit

private let height: CGFloat = 50
private let borderColorNormal: UIColor = .blue
private let borderColorHighlighted: UIColor = .red
final class VanillaLoginViewController: UIViewController, StackViewOwner {
    
    lazy var emailField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Email"
        field.layer.borderWidth = 2
        field.font = .big
        field.delegate = self
        field.addConstraint(field.heightAnchor.constraint(equalToConstant: height))
        return field
    }()
    
    lazy var passwordField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Password"
        field.layer.borderWidth = 2
        field.font = .big
        field.delegate = self
        field.addConstraint(field.heightAnchor.constraint(equalToConstant: height))
        return field
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = height/2
        button.addConstraint(button.heightAnchor.constraint(equalToConstant: height))
        button.setTitle("Login", for: .normal)
        button.setTitle("Logging in..", for: .highlighted)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.red, for: .highlighted)
        button.backgroundColor = .green
        button.layer.borderColor = borderColorNormal.cgColor
        button.layer.borderWidth = 2
        button.titleLabel?.font = .big
        button.addTarget(self, action: #selector(loginButtonPressed), for: .primaryActionTriggered)
        button.addTarget(self, action: #selector(useBorderColorHighlighted), for: .touchDown)
        button.addTarget(self, action: #selector(useBorderColorNormal), for: .touchUpInside)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.emailField, self.passwordField, self.loginButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        let margins: CGFloat = 20
        stackView.layoutMargins = UIEdgeInsets(top: margins, left: margins, bottom: margins, right: margins)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        title = "Vanilla - LoginViewController"
    }
}

extension VanillaLoginViewController: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.validate()
    }
}

private extension VanillaLoginViewController {
    @objc func loginButtonPressed() {
        print("should login")
    }
    
    @objc func useBorderColorHighlighted() {
        loginButton.layer.borderColor = borderColorHighlighted.cgColor
    }
    
    @objc func useBorderColorNormal() {
        loginButton.layer.borderColor = borderColorNormal.cgColor
    }
}
