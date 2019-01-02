//
//  TrackedUserAction.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

/// A trackable event that was directly or indirectly initiated by the user.
/// You should probably make this an enum. And you _SHOULD_ name the cases
/// like they where prefix with the words "user did".
///
/// Example:
/// For `ChoosePincodeUserAction` we have the the two cases:
///   * skip
///   * chosePincode
/// Which should read out like "user did skip" and "user did chose pincode"
/// respectively.
protocol TrackedUserAction: TrackableEvent {}
