//
//  UserDefaults+KeyValueStoring.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

// MARK: - KeyValueStoring
extension UserDefaults: KeyValueStoring {

    func deleteValue(for key: String) {
        removeObject(forKey: key)
    }

    typealias Key = PreferencesKey

    func save(value: Any, for key: String) {
        self.setValue(value, forKey: key)
    }

    func loadValue(for key: String) -> Any? {
        return value(forKey: key)
    }
}

