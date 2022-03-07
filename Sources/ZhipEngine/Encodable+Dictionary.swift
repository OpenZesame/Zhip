//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-02-25.
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
