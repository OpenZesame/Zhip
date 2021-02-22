//// 
//// MIT License
////
//// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
//// 
//// Permission is hereby granted, free of charge, to any person obtaining a copy
//// of this software and associated documentation files (the "Software"), to deal
//// in the Software without restriction, including without limitation the rights
//// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//// copies of the Software, and to permit persons to whom the Software is
//// furnished to do so, subject to the following conditions:
//// 
//// The above copyright notice and this permission notice shall be included in all
//// copies or substantial portions of the Software.
//// 
//// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//// SOFTWARE.
////
//
//import Foundation
//import RxTest
//import RxCocoa
//import RxSwift
//
///// stolen from: https://github.com/RxSwiftCommunity/RxTestExt/blob/master/RxTestExt/Core/TestScheduler%2BExt.swift
//extension TestScheduler {
//
//    /// Builds testable observer for s specific observable sequence, binds it's results and sets up disposal.
//    ///
//    //  This function was copied from RxSwift's example app:
//    //  https://github.com/ReactiveX/RxSwift/blob/f639ff450487340a18931a7dbe3d5c8a0976be7b/RxExample/RxExample-iOSTests/TestScheduler%2BMarbleTests.swift#L189
//    //
//    /// - Parameter source: Observable sequence to observe.
//    /// - Returns: Observer that records all events for observable sequence.
//    public func record<O: ObservableConvertibleType>(_ source: O) -> TestableObserver<O.E> {
//        let observer = self.createObserver(O.E.self)
//        let disposable = source.asObservable().subscribe(observer)
//        self.scheduleAt(100000) {
//            disposable.dispose()
//        }
//        return observer
//    }
//
//    /// Binds given events to an observer
//    ///
//    /// Builds a hot observable with predefined events, binds it's result to given observer and sets up disposal.
//    ///
//    /// - Parameters:
//    ///   - events: Array of recorded events to emit over the scheduled observable
//    ///   - target: Observer to bind to
//    public func bind<O: ObserverType>(_ events: [Recorded<Event<O.E>>], to target: O) {
//        let driver = self.createHotObservable(events)
//        let disposable = driver.asObservable().subscribe(target)
//        self.scheduleAt(100000) {
//            disposable.dispose()
//        }
//    }
//}
