//
//  NewPINCodeViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-20.
//

import Foundation
import ZhipEngine
import Combine

final class NavigationStepper<Step>: Publisher {
    private let stepSubject = PassthroughSubject<Output, Failure>()
    init() {}
    func step(_ step: Step) {
        stepSubject.send(step)
    }

}

// MARK: - Publisher
// MARK: -
extension NavigationStepper {
    typealias Output = Step
    typealias Failure = Never
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        stepSubject.receive(subscriber: subscriber)
    }
    
    func subscribe<S>(_ subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        stepSubject.subscribe(subscriber)
    }
    
}

enum NewPINCodeNavigationStep {
    case skipSettingPin
    case setPIN(Pincode)
}

protocol NewPINCodeViewModel: ObservableObject {
    func skip()
    var pinFieldText: String { get set }
    var pinCode: Pincode? { get set }
    var canProceed: Bool { get }
    func doneSettingPIN()
}

extension NewPINCodeViewModel {
    typealias Navigator = NavigationStepper<NewPINCodeNavigationStep>
}
