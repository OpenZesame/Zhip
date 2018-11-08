//
//  AnyKeyValueStoring.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

/// A simple non thread safe, non async, key value store without associatedtypes
protocol AnyKeyValueStoring {
    func save(value: Any, for key: String)
    func loadValue(for key: String) -> Any?
    func deleteValue(for key: String)
}
