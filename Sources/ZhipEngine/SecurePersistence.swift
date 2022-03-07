//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-02-11.
//

import Foundation

extension RawRepresentable where RawValue == String {
    public typealias ID = RawValue
    public var id: ID { rawValue }
}
