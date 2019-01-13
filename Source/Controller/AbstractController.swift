//
//  AbstractController.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AbstractController: UIViewController {
    let rightBarButtonSubject = PublishSubject<Void>()
    let leftBarButtonSubject = PublishSubject<Void>()
    lazy var rightBarButtonAbtractTarget = AbstractTarget(triggerSubject: rightBarButtonSubject)
    lazy var leftBarButtonAbtractTarget = AbstractTarget(triggerSubject: leftBarButtonSubject)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        registerForNotifications()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        unregisterFromNotifications()
    }

    func handleKeyboardWillShow(_ keyboardSize: CGSize) {}

    func handleKeyboardWillHide() {}
}

extension AbstractController {
    override var description: String {
        return "\(type(of: self))"
    }
}

private extension AbstractController {
    func registerForNotifications() {
        registerForKeyboardNotifications()
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unregisterFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardSize = view.convert(keyboardFrame.cgRectValue, from: nil).size
        handleKeyboardWillShow(keyboardSize)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        handleKeyboardWillHide()
    }
}
