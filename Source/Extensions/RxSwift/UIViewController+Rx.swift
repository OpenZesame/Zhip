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

import UIKit

import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    
    var viewDidLoad: Driver<Void> {
        return sentMessage(#selector(UIViewController.viewDidLoad))
            .mapToVoid()
            .asDriverOnErrorReturnEmpty()
    }
    
    var viewWillAppear: Driver<Void> {
        return sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorReturnEmpty()
    }
    
    var viewDidAppear: Driver<Void> {
        return sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorReturnEmpty()
    }
}
