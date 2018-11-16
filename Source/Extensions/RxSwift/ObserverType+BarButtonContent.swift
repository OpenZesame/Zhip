//
//  ObserverType+BarButtonContent.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-16.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift

extension ObserverType where Self.E == BarButtonContent {
    func onBarButton(_ predefined: BarButton) {
        onNext(predefined.content)
    }
}
