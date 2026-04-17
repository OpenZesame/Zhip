//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//

import Combine
import UIKit

extension InputPincodeView {
    var becomeFirstResponderBinder: Binder<Void> {
        pinField.becomeFirstResponderBinder
    }

    var pincodePublisher: AnyPublisher<Pincode?, Never> {
        pinField.pincodePublisher
    }

    var validationBinder: Binder<AnyValidation> {
        Binder<AnyValidation>(self) {
            $0.validate($1)
        }
    }
}
