//
//  Macros.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-30.
//
//

import Foundation

func requiredInit() -> Never {
    fatalError("Needed by compiler")
}

func abstractMethod() -> Never {
    fatalError("This method should be implemented by subclass")
}

var notSupported: Never {
    fatalError("Not supported")
}
