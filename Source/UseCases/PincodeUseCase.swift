//
//  PincodeUseCase.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

protocol PincodeUseCase: AnyObject {
    func userChoose(pincode: Pincode)
    func skipSettingUpPincode()
    func deletePincode()
    var pincode: Pincode? { get }
    var hasConfiguredPincode: Bool { get }
}
