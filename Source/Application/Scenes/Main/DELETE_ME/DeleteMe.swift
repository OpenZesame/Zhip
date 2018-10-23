//
//  DeleteMe.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-19.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

struct AuthToken {}
struct NewAccount {}
struct Credentials {}
struct Email {}
struct Phone {}

enum PasswordReset {
    case email(Email)
    case phone(Phone)
}

protocol AuthenticationUseCase {
    func signIn(using credentials: Credentials) -> Observable<AuthToken>
    func signUp(newAccount: NewAccount) -> Observable<AuthToken>
    func resetPassword(using passwordReset: PasswordReset) -> Observable<Void>
}

protocol AuthenticationCoordinator {
    func toSignIn()
    func toResetPassword()
    func toSignUp()
}

struct SignInViewModel: ViewModelType {

    private let bag = DisposeBag()
    private let useCase: AuthenticationUseCase


}

extension SignInViewModel {
    struct Input: InputType {
        struct FromView {
            let signInTrigger: Driver<Void>
        }
        let fromView: FromView
        let fromController: ControllerInput

        init(fromView: FromView, fromController: ControllerInput) {
            self.fromView = fromView
            self.fromController = fromController
        }

    }
    struct Output {}

    func transform(input: Input) -> Output {
        return Output()
//        [
//            input.fromView.signInTrigger.flatMapLatest
//            ].forEach {}
    }
}


final class SignInView: UIView {
    let button: UIButton = ""
}
extension SignInView: ViewModelled {
    var userInput: UserInput {
        return UserInput(signInTrigger: button.rx.tap.asDriverOnErrorReturnEmpty())
    }

    typealias ViewModel = SignInViewModel


}


typealias SignIn = Scene<SignInView>
