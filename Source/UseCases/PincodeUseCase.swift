//
//  PincodeUseCase.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

protocol PincodeUseCase: AnyObject {
    func userChoose(pincode: Pincode)
    func skipSettingUpPincode()
    func deletePincode()
    func doesPincodeMatchChosen(_ pincode: Pincode?) -> Bool
    var hasConfiguredPincode: Bool { get }
}
