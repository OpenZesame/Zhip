//
//  ViewStyle+Optional+Operators.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-08.
//
//

import Foundation

public func <<- (lhs: ViewStyle?, rhs: ViewAttribute) -> ViewStyle {
    return lhs.merge(master: ViewStyle([rhs]))
}

public func <<- (lhs: ViewAttribute, rhs: ViewStyle?) -> ViewStyle {
    return rhs <- lhs
}

public func <- (lhs: ViewStyle?, rhs: ViewAttribute) -> ViewStyle {
    return lhs.merge(slave: ViewStyle([rhs]))
}

public func <- (lhs: ViewAttribute, rhs: ViewStyle?) -> ViewStyle {
    return rhs <<- lhs
}

