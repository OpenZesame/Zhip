//
//  DispatchQueue+Sugar.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-09-23.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

func background(delay: DispatchTimeInterval = .seconds(0), work: @escaping () -> ()) {
    DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + delay) {
        work()
    }
}

func main(work: @escaping () -> ()) {
    DispatchQueue.main.async {
        work()
    }
}
