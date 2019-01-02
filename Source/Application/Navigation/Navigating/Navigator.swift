import Foundation
import RxSwift
import RxCocoa

/// A type capable of stepping to `NavigationStep`s, passed as a generic.
///
/// Conforming to `Tracking`, thus capable of tracking the steps which are
/// marked as `Trackable`.
final class Navigator<NavigationStep> {

    private let navigationSubject: PublishSubject<NavigationStep>
    private let tracker: Tracking

    lazy var navigation = navigationSubject.asDriverOnErrorReturnEmpty()

    init(navigationSubject: PublishSubject<NavigationStep> = PublishSubject<NavigationStep>(), tracker: Tracking = Tracker()) {
        self.navigationSubject = navigationSubject
        self.tracker = tracker
    }
}

extension Navigator {
    func next(_ step: NavigationStep) {
        navigationSubject.onNext(step)

        if let userAction = step as? TrackableEvent {
            return track(event: userAction)
        }

        guard let userAction = findNestedEnumOfType(TrackableEvent.self, in: step, recursiveTriesLeft: 3) else { return }

        track(event: userAction)
    }
}

extension Navigator: Tracking {
    func track(event: TrackableEvent, context: Any = NoContext()) {
        tracker.track(event: event, context: context)
    }
}
