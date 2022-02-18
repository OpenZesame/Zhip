//
//  JSONEncoder+Extensions.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-18.
//

import Foundation

extension JSONEncoder {
    convenience init(outputFormatting: JSONEncoder.OutputFormatting) {
        self.init()
        self.outputFormatting = outputFormatting
    }
}
