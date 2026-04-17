// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import Foundation

struct InputFromController {
    let viewDidLoad: AnyPublisher<Void, Never>
    let viewWillAppear: AnyPublisher<Void, Never>
    let viewDidAppear: AnyPublisher<Void, Never>

    let leftBarButtonTrigger: AnyPublisher<Void, Never>
    let rightBarButtonTrigger: AnyPublisher<Void, Never>

    let titleSubject: PassthroughSubject<String, Never>
    let leftBarButtonContentSubject: PassthroughSubject<BarButtonContent, Never>
    let rightBarButtonContentSubject: PassthroughSubject<BarButtonContent, Never>
    let toastSubject: PassthroughSubject<Toast, Never>
}
