// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import UIKit

// MARK: - UIControl event publisher

public struct UIControlPublisher<Control: UIControl>: Publisher {
    public typealias Output = Void
    public typealias Failure = Never

    let control: Control
    let events: UIControl.Event

    public func receive<S: Subscriber>(subscriber: S)
        where S.Input == Void, S.Failure == Never {
        let subscription = UIControlSubscription(
            subscriber: subscriber,
            control: control,
            events: events
        )
        subscriber.receive(subscription: subscription)
    }
}

final class UIControlSubscription<S: Subscriber, Control: UIControl>: Subscription
    where S.Input == Void, S.Failure == Never {

    private var subscriber: S?
    private weak var control: Control?
    private let events: UIControl.Event

    init(subscriber: S, control: Control, events: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        self.events = events
        control.addTarget(self, action: #selector(handleEvent), for: events)
    }

    public func request(_ demand: Subscribers.Demand) {}

    public func cancel() {
        control?.removeTarget(self, action: #selector(handleEvent), for: events)
        subscriber = nil
    }

    @objc private func handleEvent() {
        _ = subscriber?.receive(())
    }
}

// MARK: - UIControl extension

public extension UIControl {
    func publisher(for events: UIControl.Event) -> UIControlPublisher<UIControl> {
        UIControlPublisher(control: self, events: events)
    }
}
