//
//  JSONEncoder+Extensions.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-26.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

extension JSONEncoder {
    convenience init(outputFormatting: JSONEncoder.OutputFormatting) {
        self.init()
        self.outputFormatting = outputFormatting
    }
}
