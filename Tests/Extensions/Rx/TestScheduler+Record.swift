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

import Foundation
import RxTest
import RxCocoa
import RxSwift

/// stolen from: https://github.com/RxSwiftCommunity/RxTestExt/blob/master/RxTestExt/Core/TestScheduler%2BExt.swift
extension TestScheduler {

    /// Builds testable observer for s specific observable sequence, binds it's results and sets up disposal.
    ///
    //  This function was copied from RxSwift's example app:
    //  https://github.com/ReactiveX/RxSwift/blob/f639ff450487340a18931a7dbe3d5c8a0976be7b/RxExample/RxExample-iOSTests/TestScheduler%2BMarbleTests.swift#L189
    //
    /// - Parameter source: Observable sequence to observe.
    /// - Returns: Observer that records all events for observable sequence.
    public func record<O: ObservableConvertibleType>(_ source: O) -> TestableObserver<O.E> {
        let observer = self.createObserver(O.E.self)
        let disposable = source.asObservable().subscribe(observer)
        self.scheduleAt(100000) {
            disposable.dispose()
        }
        return observer
    }

    /// Binds given events to an observer
    ///
    /// Builds a hot observable with predefined events, binds it's result to given observer and sets up disposal.
    ///
    /// - Parameters:
    ///   - events: Array of recorded events to emit over the scheduled observable
    ///   - target: Observer to bind to
    public func bind<O: ObserverType>(_ events: [Recorded<Event<O.E>>], to target: O) {
        let driver = self.createHotObservable(events)
        let disposable = driver.asObservable().subscribe(target)
        self.scheduleAt(100000) {
            disposable.dispose()
        }
    }
}
