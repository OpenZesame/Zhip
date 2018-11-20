import Foundation
import RxSwift
import RxCocoa

final class Stepper<Step> {

    private let navigationSubject: PublishSubject<Step>
    private let tracker: Tracking

    lazy var navigation = navigationSubject.asDriverOnErrorReturnEmpty()

    init(navigationSubject: PublishSubject<Step> = PublishSubject<Step>(), tracker: Tracking = Tracker()) {
        self.navigationSubject = navigationSubject
        self.tracker = tracker
    }
}

extension Stepper {
    func step(_ step: Step) {
        navigationSubject.onNext(step)

        if let userAction = step as? TrackedUserAction {
            return track(event: userAction)
        }

        guard let userAction = findNestedEnumOfType(TrackedUserAction.self, in: step, recursiveTriesLeft: 3) else { return }

        track(event: userAction)
    }
}

extension Stepper: Tracking {
    func track(event: TrackableEvent, context: Any = NoContext()) {
        tracker.track(event: event, context: context)
    }
}
