//
//  NavigationStepper.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-24.
//

import Foundation
import Combine

// MARK: - NavigationStepper
// MARK: -
public final class NavigationStepper<Step>: Publisher {
    private let stepSubject: PassthroughSubject<Output, Failure>
    
    public init(
        stepSubject: PassthroughSubject<Output, Failure> = .init()
    ) {
        self.stepSubject = stepSubject
    }
    
}

// MARK: - Public
// MARK: -
public extension NavigationStepper {
    func step(_ step: Step) {
        stepSubject.send(step)
    }
}

// MARK: - Publisher
// MARK: -
public extension NavigationStepper {
    typealias Output = Step
    typealias Failure = Never
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        stepSubject.receive(subscriber: subscriber)
    }
    
    func subscribe<S>(_ subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        stepSubject.subscribe(subscriber)
    }
    
}
