//
//  DigitViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-21.
//

import Foundation
import ZhipEngine

final class DigitViewModel: Identifiable, ObservableObject {
    typealias ID = UUID
    let digit: Digit?
    let id = ID()
    init(digit: Digit?) {
        self.digit = digit
    }
}
