//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
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
