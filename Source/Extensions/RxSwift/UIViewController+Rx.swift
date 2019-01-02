//
//  UIViewController+Rx.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-10-23.
//  Copyright © 2018 Open Zesame. All rights reserved.
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
