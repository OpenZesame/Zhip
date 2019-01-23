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

import UIKit

extension UILayoutPriority: ExpressibleByFloatLiteral {
    public init(floatLiteral rawValue: Float) {
        self.init(rawValue: rawValue)
    }
}

extension UILayoutPriority: ExpressibleByIntegerLiteral {
    public init(integerLiteral intValue: Int) {
        self.init(rawValue: Float(intValue))
    }
}

public extension UILayoutPriority {
    static var medium: UILayoutPriority {
        let delta = UILayoutPriority.defaultHigh.rawValue - UILayoutPriority.defaultLow.rawValue
        let valueBetweenLowAndHeigh = UILayoutPriority.defaultLow.rawValue + delta / 2
        return UILayoutPriority(rawValue: valueBetweenLowAndHeigh)
    }
}
