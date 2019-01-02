//
//  Encodable+Dictionary.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-06.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public extension Encodable {
    var dictionaryRepresentation: [String: Any] {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            return jsonObject ?? [:]
        } catch {
            return [:]
        }
    }
}
