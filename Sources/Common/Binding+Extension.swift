//
//  Binding+Extension.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-22.
//

import Foundation
import SwiftUI

extension Binding {
    func getOnly<T>(mapped transformation: @escaping (Value) -> T) -> Binding<T> {
        .init(
            get: { transformation(wrappedValue) },
            set: { newT in fatalError("Unable to transform value: '\(newT)' of type: \(type(of: newT)) to this bindings type: \(Value.self)), this is a get only binding.") }
        )
    }
    
}
extension Binding where Value: OptionalType {
    func getOnly<T>(ifNil: T, mapUnwrapped: @escaping (Value.Wrapped) -> T) -> Binding<T> {
        getOnly(mapped: {
            if let unwrapped = $0.wrapped {
                return mapUnwrapped(unwrapped)
            } else {
                return ifNil
            }
        })
    }
    
    func ifPresent<T>(_ mapInspectIfPresent: @escaping (_ isSet: Bool) -> T) -> Binding<T> {
        getOnly(mapped: {
            mapInspectIfPresent($0.wrapped != nil)
        })
    }
}
