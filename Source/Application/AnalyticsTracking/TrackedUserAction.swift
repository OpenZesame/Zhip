//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
protocol TrackedUserAction: TrackableEvent, RawRepresentable {}
