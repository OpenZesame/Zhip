//
//  LoginViewController.swift
//  Example
//
//  Created by Alexander Cyon on 2017-06-10.
//  Copyright © 2017 Alexander Cyon. All rights reserved.
//

import UIKit
import ViewComposer

private let height: CGFloat = 50
private let style: ViewStyle = [.font(.big), .height(height), .clipsToBounds(true) ]
private let borderStyle = style <<- .borderWidth(2)
private let borderColorNormal: UIColor = .blue

final class LoginViewController: UIViewController, StackViewOwner {
    
    lazy var emailField: UITextField = borderStyle <<- [.placeholder("Email"), .delegate(self)]
    lazy var passwordField: UITextField = borderStyle <<- [.placeholder("Password"), .delegate(self)]
    
    lazy var loginButton: Button = borderStyle
        <<- .states([
            Normal("Login", titleColor: .blue, backgroundColor: .green, borderColor: borderColorNormal),
            Highlighted("Logging in...", titleColor: .red, backgroundColor: .yellow, borderColor: .red)
        ])
        <- .target(self.target(#selector(loginButtonPressed)))
        <- [.roundedBy(.height)]
    
    var views: [UIView] { return [emailField, passwordField, loginButton] }
    lazy var stackView: UIStackView = .axis(.vertical) <- .views(self.views)
        <- [.spacing(20), .margin(20)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        title = "ViewComposer - LoginViewController"
    }
}

extension LoginViewController: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.validate()
    }
}

private extension LoginViewController {
    @objc func loginButtonPressed() {
        print("should login")
    }
}
