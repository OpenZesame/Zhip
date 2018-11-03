import Foundation
import RxSwift
import RxCocoa

final class Stepper<Step> {

    private let navigationSubject: PublishSubject<Step>
    private let tracker: Tracking

    init(navigationSubject: PublishSubject<Step> = PublishSubject<Step>(), tracker: Tracking = Tracker(preferences: KeyValueStore(UserDefaults.standard))) {
        self.navigationSubject = navigationSubject
        self.tracker = tracker
    }
}

extension Stepper {

    var navigationSteps: Driver<Step> {
        return navigationSubject.asDriverOnErrorReturnEmpty()
    }

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
    func track(event: TrackableEvent) {
        tracker.track(event: event)
    }
}
